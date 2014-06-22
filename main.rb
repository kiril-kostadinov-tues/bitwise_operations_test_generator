class Task
	attr_accessor :x
	attr_accessor :body

	def initialize(x, body)
		@x = x
		@body = body
	end
end

def hex_length(l)
	num = "0x#{rand(1..((16**l) - 1)).to_s(16)}"
end

def hex_range(range)
	num = "0x#{rand(range).to_s(16)}"
end

def dec_length(l)
	num = rand(1..((10**l) - 1)).to_s
end

def dec_range(range)
	num = rand(range).to_s
end

class EasyTaskGenerator
	def generate_task(number)
		x = []
		body = ""
		File.open("easyTask#{number}.txt").each_with_index do |line, index|
			if index == 0
				x = line.gsub("\n", "").split(',')
				next
			end
			body += line
		end
		num = rand(15)
		body = eval('"' + body + '"')
		Task.new(x, body)
	end
end

class HardTaskGenerator
	def generate_task(number)
		x = []
		body = ""
		File.open("hardTask#{number}.txt").each_with_index do |line, index|
			if index == 0
				x = line.gsub("\n", "").split(',')
				next
			end
			body += line
		end
		body = eval('"' + body + '"')
		Task.new(x, body)
	end
end

generator = EasyTaskGenerator.new
p generator.generate_task(1)