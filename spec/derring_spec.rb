require 'derring-do'
require 'stringio'

class Interrupted < RuntimeError; end
trap("INT") { raise Interrupted }

describe "derring" do
  before(:each) do
    @io = StringIO.new
    DerringDo.configuration[:output_to] = @io
    DerringDo.configuration[:update_wait_time] = 5
    DerringDo.configuration[:minor_wait_time] = 1
  end

  context "without a block" do
    it "raises an exception" do
      expect{derring}.to raise_error(ArgumentError)
    end
  end

  context "with no target" do
    it "provides a campaign to the block" do
      called = false

      derring do |campaign|
        called = true
        campaign.should_not == nil
      end

      called.should == true
    end

    it "increments progress when tally_ho! is called on the campaign" do
      derring do |campaign|
        expect{campaign.tally_ho!}.to change{campaign.progress}.from(0).to(1)
      end
    end

    it "shouts encouragement initially" do
      derring do |campaign|
        expect{campaign.tally_ho!}.to change{@io.string.length}
      end
    end

    it "shouts encouragement when time has elapsed" do
      DerringDo.configuration[:update_wait_time] = 0.5

      derring do |campaign|
        campaign.tally_ho!
        expect{campaign.tally_ho!}.to_not change{@io.string.length}
        sleep 0.5
        expect{campaign.tally_ho!}.to change{@io.string.length}
      end
    end
  end

  context "with a target" do
    it "provides a campaign to the block" do
      called = false

      derring do |campaign|
        called = true
        campaign.should_not == nil
        campaign.target = 100
        campaign.target.should == 100
      end

      called.should == true
    end

    it "increments progress when tally_ho! is called on the campaign" do
      derring do |campaign|
        campaign.target = 100
        expect{campaign.tally_ho!}.to change{campaign.progress}.from(0).to(1)
      end
    end

    it "moves toward completion when tally_ho!(n) is called on the campaign" do
      derring do |campaign|
        campaign.target = 100
        expect{campaign.tally_ho! 5}.to change{campaign.progress}.from(0).to(5)
      end
    end

    it "displays progress when some time has elapsed" do
      DerringDo.configuration[:minor_wait_time] = 0.1

      derring do |campaign|
        campaign.target = 100
        expect{campaign.tally_ho! 5}.to change{@io.string.length}
        expect{campaign.tally_ho! 5}.to_not change{@io.string.length}
        sleep 0.1
        expect{campaign.tally_ho! 5}.to change{@io.string.length}
      end
    end

    it "only shouts encouragement when more time has elapsed" do
      DerringDo.configuration[:minor_wait_time] = 5
      DerringDo.configuration[:update_wait_time] = 0.1

      derring do |campaign|
        campaign.target = 100
        expect{campaign.tally_ho! 5}.to change{@io.string.length}
        expect{campaign.tally_ho! 5}.to_not change{@io.string.length}
        sleep 0.1
        expect{campaign.tally_ho! 5}.to change{@io.string.length}
      end
    end

    it "shouts congratulations when the target is achieved" do
      derring do |campaign|
        campaign.target = 100
        expect{campaign.tally_ho! 5}.to change{@io.string.length}
        expect{campaign.tally_ho! 95}.to change{@io.string.length}
      end
    end
  end

  context "when an error occurs" do
    it "shouts a panicked exclamation" do
      expect do
        expect do
          derring do |campaign|
            raise "ouch!"
          end
        end.to raise_error(RuntimeError)
      end.to change{@io.string.length}
    end
  end

  context "when aborted" do
    it "shouts insults" do
      expect do
        expect do
          derring do |campaign|
            Process.kill("INT", $$)
          end
        end.to raise_error(Interrupted)
      end.to change{@io.string.length}
    end
  end
end
