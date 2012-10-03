VestalVersions.configure do |config|
  # Place any global options here. For example, in order to specify your own version model to use
  # throughout the application, simply specify:
  #
  # config.class_name = "MyCustomVersion"
  #
  # Any options passed to the "versioned" method in the model itself will override this global
  # configuration.
end

####
#
#   Fix for vestal_versions not working out of box with ActiveRecord 3.2.0 (Rails 3.2.0).
#   lib/vestal_versions/versions.rb
#   :order => "#{table_name}.#{connection.quote_column_name('number')} #{(from_number > to_number) ? 'DESC' : 'ASC'}"
#   -- aliased_table_name
#   ++ table_name
#
#   lib/vestal_versions/options.rb
#   class_attribute :vestal_versions_options
#   -- class_inheritable_accessor 
#   ++ class_attribute#
#
####
module VestalVersions
  # An extension module for the +has_many+ association with versions.
  module Versions
    def between(from, to)
      from_number, to_number = number_at(from), number_at(to)
      return [] if from_number.nil? || to_number.nil?

      condition = (from_number == to_number) ? to_number : Range.new(*[from_number, to_number].sort)
      all(
        :conditions => {:number => condition},
        :order => "#{table_name}.#{connection.quote_column_name('number')} #{(from_number > to_number) ? 'DESC' : 'ASC'}"
      )
    end
  end
end

module VestalVersions
  # Provides +versioned+ options conversion and cleanup.
  module Options
    extend ActiveSupport::Concern

    module ClassMethods
      def prepare_versioned_options(options)
        options.symbolize_keys!
        options.reverse_merge!(VestalVersions.config)
        options.reverse_merge!(
          :class_name => 'VestalVersions::Version',
          :dependent => :delete_all
        )
        class_attribute :vestal_versions_options
        self.vestal_versions_options = options.dup

        options.merge!(
          :as => :versioned,
          :extend => Array(options[:extend]).unshift(Versions)
        )
      end
    end
  end
end
