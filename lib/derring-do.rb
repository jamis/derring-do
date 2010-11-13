module DerringDo
  @@configuration = { 
    :update_wait_time => 5, # seconds
    :minor_wait_time => 1,  # seconds
    :output_to => STDOUT,   # where output is written
  }

  def self.configuration
    @@configuration
  end

  class Campaign
    attr_reader :progress
    attr_accessor :target

    def initialize
      @progress = 0
      @target = nil
      @last_update_at = Time.now - DerringDo.configuration[:update_wait_time]
      @last_minor_update_at = Time.now - DerringDo.configuration[:minor_wait_time]
    end

    def tally_ho!(n=1)
      @progress += n
      inform_if_ready
    end

    PANIC_WORDS = [
      "Retreat!",
      "Thomas Jefferson...still survives...",
      "Nothing...but death.",
      "Et tu, Brute?",
      "I have tried so hard to do the right!",
      "They couldn't hit an elephant at this dist--",
    ]

    def failed_with(error) #:nodoc:
      panic = PANIC_WORDS[rand(PANIC_WORDS.length)]
      DerringDo.configuration[:output_to].puts(panic)
    end

    INSULTS_ADJECTIVES = %w(yellow-bellied two-faced two-timing no-good spineless)
    INSULTS_NOUNS = ["coward", "Benedict Arnold", "traitor", "wimp"]

    def aborted! #:nodoc:
      adj = INSULTS_ADJECTIVES.sort_by { rand }[0,3].join(", ")
      noun = INSULTS_NOUNS[rand(INSULTS_NOUNS.length)]
      DerringDo.configuration[:output_to].puts(adj + " " + noun + "!")
    end

    private

    ENCOURAGING_WORDS = [
      "Charge!",
      "Into the breach!",
      "Faugh a ballaugh!",
      "Vive la Ruby!",
      "Senta a pua!",
    ]

    CONGRATULATIONS = [
      "Bob's yer uncle!",
      "GADZOOKS!",
      "Oh, I say! Well done!",
      "Jolly good show!",
      "By Jove! I think you've done it!",
    ]

    def inform_if_ready
      now = Time.now

      if target && progress >= target
        word = CONGRATULATIONS[rand(CONGRATULATIONS.length)]
        DerringDo.configuration[:output_to].puts(word)
      elsif now - @last_update_at >= DerringDo.configuration[:update_wait_time]
        @last_minor_update_at = @last_update_at = now
        word = ENCOURAGING_WORDS[rand(ENCOURAGING_WORDS.length)]
        DerringDo.configuration[:output_to].puts(word)
      elsif target && now - @last_minor_update_at >= DerringDo.configuration[:minor_wait_time]
        @last_minor_update_at = now
        DerringDo.configuration[:output_to].puts "#{progress} / #{target}"
      end
    end
  end

  module Implementation
    def derring
      raise ArgumentError, "`derring' requires a block" unless block_given?

      campaign = Campaign.new

      begin
        yield campaign
      rescue Interrupt
        campaign.aborted!
        raise
      rescue Exception => error
        campaign.failed_with(error)
        raise
      end
    end
  end
end

class Object
  if instance_methods.any? { |i| i.to_sym == :derring }
    warn "Object#derring is already present; the `derring-do' gem may behave oddly."
  end

  include DerringDo::Implementation
end
