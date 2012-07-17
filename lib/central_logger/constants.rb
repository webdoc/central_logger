module CentralLogger
  module Constants

    # Easy to access information for calculating capped collections
    MB = 2 ** 20
    PRODUCTION_COLLECTION_SIZE = 256 * MB
    DEFAULT_COLLECTION_SIZE = 128 * MB
    PRODUCTION_NUM_OBJECTS = 10000000
    DEFAULT_NUM_OBJECTS = 10000000

    # Looks for configuration files in this order
    CONFIGURATION_FILES = ["central_logger.yml", "mongoid.yml", "database.yml"]

  end
end