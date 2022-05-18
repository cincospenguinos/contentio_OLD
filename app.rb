require 'sinatra'
require 'securerandom'

class Content
	TEXT_COLOR_LIGHT_THRESHOLD = 186

	def initialize(seed = nil)
		@rand = Random.new
		@rand = Random.new(seed) unless seed.nil?
	end

	def primary
		@primary ||= @rand.rand(0xffffff).to_s(16).split('').each_slice(2).map(&:join).map { |a| a.length == 1 ? "0#{a}" : a }.join
	end

	def secondary
		tinted_primary = hexstr_to_rgb(primary).map { |a| [0, a - 64].max }
		rgb_to_hexstr(tinted_primary)
	end

	def accent
		return @accent unless @accent.nil?
		accent_int = primary.to_i(16) ^ 0xffffff
		accent_int.to_s(16)
	end

	def text_color
		tmp = hexstr_to_rgb(primary)
		lightness = tmp[0] * 0.299 + tmp[1] * 0.587 + tmp[2] * 0.114
		return '000000' if lightness > TEXT_COLOR_LIGHT_THRESHOLD
		'ffffff'
	end

	def text_size
		120 + @rand.rand(60)
	end

	private

	def hexstr_to_rgb(color_str)
		color_str.split('').each_slice(2).map(&:join).map { |a| a.to_i(16) }
	end

	def rgb_to_hexstr(rgb)
		rgb.map{ |a| a.to_s(16) }.map { |a| a.length == 1 ? "0#{a}" : a }.join
	end
end

get '/' do
	@content = Content.new
	erb :index
end