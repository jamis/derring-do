require 'derring-do'

derring do |campaign|
  1000.times do
    campaign.tally_ho!
    sleep 0.02
  end
end
