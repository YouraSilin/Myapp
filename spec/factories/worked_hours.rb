FactoryBot.define do
  factory :worked_hour do
    day_of_month { 20 }
    hours { 8.0 }
    note { '' }
    fill { 'ffffff' }
  end
end
