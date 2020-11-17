# frozen_string_literal: true

class UseCase
  include ActiveModel::Validations

  class << self
    def arguments(*keys)
      keys.each do |key|
        define_method(key) do
          params.fetch(key) { raise ArgumentError, "Missing #{key} in params" }
        end
      end
    end

    def params_reader(*keys)
      keys.each do |key|
        define_method(key) do
          params.fetch(key, nil)
        end
      end
    end

    def call(params:)
      new(params: params).call
    end
  end

  def call
    ActiveRecord::Base.transaction do
      validate!
      persist
    end
  end

  def initialize(params:)
    @params = params
  end

  private

  attr_reader :params
end