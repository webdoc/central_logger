module CentralLogger
  class LogMessage

    ## Mixins

    include Mongoid::Document

    ## MongoDB Configs

    store_in collection: "logs"

    ## Fields

    field :t, as: :time, type: DateTime, default: ->{ Time.now }
    field :m, as: :message, type: String
    field :ms, as: :messages
    field :s, as: :severity, type: String
    field :p, as: :progname, type: String
    field :r, as: :runtime, type: Integer

    ## Sharding

    shard_key :t

  end
end