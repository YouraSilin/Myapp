class Phone < ApplicationRecord
  validates :number, :name, presence: { message: " не может быть пустым" }
end
