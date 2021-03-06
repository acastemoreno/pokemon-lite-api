class Pokemon < ApplicationRecord
    has_many :captures

    validates :name, presence: true, uniqueness: true
    validates :main_ability, :main_type, presence: true
    validates :main_type, inclusion: { in: ['bug', 'electric', 'fairy', 'fighting', 'fire', 'flying', 'grass', 'ground', 'ice', 'normal', 'poison', 'psychic', 'rock', 'steel', 'water']}
end
