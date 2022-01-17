class Team < ApplicationRecord
    validates_presence_of :name
    validates_presence_of :image
    validates_presence_of :abbrev
end
