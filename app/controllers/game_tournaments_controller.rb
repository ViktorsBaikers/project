# frozen_string_literal: true

class GameTournamentsController < ApplicationController
  before_action :set_game_tournament, only: %i[show edit update destroy matches group_game play_off final]

  # GET /game_tournaments or /game_tournaments.json
  def index
    @game_tournaments = GameTournament.all.order(created_at: :desc)
  end

  # GET /game_tournaments/1 or /game_tournaments/1.json
  def show
    group_games
    return unless @game_tournament.status == GameTournament::STATUS_DONE

    @winner = Team.find(@game_tournament.winner_id)
    @finalist = Team.find(@game_tournament.finalist_id)
  end

  # GET /game_tournaments/new
  def new
    @teams = Team.all
    @game_tournament = GameTournament.new
  end

  # GET /game_tournaments/1/edit
  def edit; end

  def group_game
    GroupGameService.new(@game_tournament.id).generate_scores
    respond_to do |format|
      if @game_tournament.update(
        status: GameTournament::STATUS_IN_PROGRESS,
        progress: Game::PLAY_OFF_STAGE
      )

        format.html do
          redirect_to game_tournament_url(@game_tournament),
                      notice: "tournament is in progress."
        end
        format.json { render :show, status: :ok, location: @game_tournament }
      else
        format.html do
          redirect_to game_tournament_url(@game_tournament),
                      notice: "problem playing play group stages."
        end
        format.json { render :show, status: 400, location: @game_tournament }
      end
    end
  end

  def play_off
    PlayOffService.new(@game_tournament.id).generate_play_off_game
    respond_to do |format|
      if @game_tournament.update(progress: Game::FINAL_STAGE)
        format.html do
          redirect_to game_tournament_url(@game_tournament),
                      notice: "tournament play-off completed."
        end
        format.json { render :show, status: :ok, location: @game_tournament }
      else
        format.html do
          redirect_to game_tournament_url(@game_tournament),
                      notice: "problem playing play off."
        end
        format.json { render :show, status: 400, location: @game_tournament }
      end
    end
  end

  def final
    result = PlayFinalService.new(@game_tournament.id).generate_finals
    respond_to do |format|
      if @game_tournament.update(
        finalist_id: result[1], winner_id: result[0],
        status: GameTournament::STATUS_DONE, progress: Game::COMPLETED
      )
        format.html do
          redirect_to game_tournament_url(@game_tournament),
                      notice: "tournament finals completed."
        end
        format.json { render :show, status: :ok, location: @game_tournament }
      else
        format.html do
          redirect_to game_tournament_url(@game_tournament),
                      notice: "problem playing final."
        end
        format.json { render :show, status: 400, location: @game_tournament }
      end
    end
  end

  # POST /game_tournaments or /game_tournaments.json
  def create
    @game_tournament = GameTournament.new(game_tournament_params)
    respond_to do |format|
      if @game_tournament.save
        AssignTeamService.new(game_tournament_params[:team_ids], @game_tournament.id).assign
        format.html do
          redirect_to game_tournament_url(@game_tournament),
                      notice: "tournament was successfully created."
        end
        format.json { render :show, status: :created, location: @game_tournament }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json do
          render json: @game_tournament.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # PATCH/PUT /game_tournaments/1 or /game_tournaments/1.json
  def update
    respond_to do |format|
      if @game_tournament.update(game_tournament_params)
        format.html do
          redirect_to game_tournament_url(@game_tournament),
                      notice: "tournament was successfully updated."
        end
        format.json { render :show, status: :ok, location: @game_tournament }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json do
          render json: @game_tournament.errors, status: :unprocessable_entity
        end
      end
    end
  end

  # DELETE /game_tournaments/1 or /game_tournaments/1.json
  def destroy
    @game_tournament.destroy!
    respond_to do |format|
      format.html do
        redirect_to game_tournaments_url, notice: "tournament was successfully destroyed."
      end
      format.json { head(:no_content) }
    end
  end

  def matches
    @games = Game.where(game_tournament: @game_tournament)
    group_games
    group_a_matches
    group_b_matches
    play_off_matches
    final_match
  end

  def group_a_matches
    @group_a_matches = []
    @group_a_games = @games.where(
      team_a_id: @group_a_team_ids, team_b_id: @group_a_team_ids,
      progress: Game::GROUP_STAGE
    )
    generate_team_hash(@group_a_matches, @group_a_games, @group_a_teams)
  end

  def group_b_matches
    @group_b_matches = []
    @group_b_games = @games.where(
      team_a_id: @group_b_team_ids, team_b_id: @group_b_team_ids,
      progress: Game::GROUP_STAGE
    )
    generate_team_hash(@group_b_matches, @group_b_games, @group_b_teams)
  end

  def play_off_matches
    @play_off_matches = []
    @all_teams = @group_a_teams + @group_b_teams
    @play_off_games = @games.where(progress: Game::PLAY_OFF_STAGE)
    generate_team_hash(@play_off_matches, @play_off_games, @all_teams)
  end

  def final_match
    @final_matches = []
    @final_game = @games.where(progress: Game::FINAL_STAGE)
    generate_team_hash(@final_matches, @final_game, @all_teams)
  end

  private

  def generate_team_hash(matches, current_match_progress, team_list)
    current_match_progress.each do |match|
      matches << {
        team_a: team_list.find { |t| t.id == match.team_a_id },
        team_b: team_list.find { |t| t.id == match.team_b_id },
        team_a_score: match.team_a_score,
        team_b_score: match.team_b_score,
        progress: match.progress
      }
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_game_tournament
    @game_tournament = GameTournament.find(params[:id])
  end

  def group_games
    groups = Group.where(game_tournament: @game_tournament)

    @group_a = groups.where(name: Group::GROUP_A)[0]
    @group_b = groups.where(name: Group::GROUP_B)[0]

    @group_a_team_ids = JSON.parse(@group_a.team_ids)
    @group_b_team_ids = JSON.parse(@group_b.team_ids)
    @group_a_teams = Team.where(id: @group_a_team_ids)
    @group_b_teams = Team.where(id: @group_b_team_ids)
  end

  # Only allow a list of trusted parameters through.
  def game_tournament_params
    params.require(:game_tournament).permit(:name, team_ids: [])
  end
end
