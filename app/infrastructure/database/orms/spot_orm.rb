# frozen_string_literal: true

require 'sequel'

module CryptoExpert
  module Database
    # Object-Relational Mapper for Members
    class SpotOrm < Sequel::Model(:spots)
        one_to_many :exchange,
                  class: :'CryptoExpert::Database::ExchangeOrm',
                  key: :exchanges
        
    #   many_to_many :contributed_projects,
    #                class: :'CodePraise::Database::ProjectOrm',
    #                join_table: :projects_members,
    #                left_key: :member_id, right_key: :project_id

      plugin :timestamps, update_on_create: true

      def self.find_or_create(symbol_name)
        # first(username: member_info[:username]) || create(member_info)
      end
    end
  end
end
