require 'derring-do'

derring do |campaign|
  campaign.target = 2000
  1000.times do
    campaign.tally_ho! 2
    sleep 0.02
  end
end
