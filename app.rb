require 'sinatra'
require 'securerandom'

class Content
	def initialize(seed = nil)
		@rand = Random.new
		@rand = Random.new(seed) unless seed.nil?
	end

	def primary
		@primary ||= SecureRandom.hex(3)
	end

	def secondary
		return @secondary unless @secondary.nil?
		@secondary = primary.split('').each_slice(2).map(&:join).map { |a| a.to_i(16) }.map { |a| [00, a - 64].max }.map { |a| a.to_s(16) }.map { |a| a.length == 1 ? "0#{a}" : a }.join
		@secondary
	end

	def accent
	end
end

get '/' do
	@content = Content.new
	erb :index
end