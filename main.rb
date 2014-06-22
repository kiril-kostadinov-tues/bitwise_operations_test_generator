require "nokogiri"

class Task
	attr_accessor :x
	attr_accessor :body

	def initialize(x, body)
		@x = x
		@body = body
	end
end

class HtmlGenerator

	attr_accessor :file_name

	def initialize(filename)
		@file_name = filename
	end

	def generate_html(tasks)
		builder = Nokogiri::HTML::Builder.new do |doc|

		doc.html {
			doc.body {
				tasks.each do |current_task|
					doc.div {
						current_task.x.each do |current|
							doc.text "#{current}, "
						end
						doc.text "= ?"
						doc.br
						current_task.body.each_char do |i|
							doc.text i
							if i == ';'
							doc.br
						end		
						end
					}
				end
			}
		}
		end
		File.open(file_name, "w") { |file| file.write(builder.to_html) }
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

tasks = []
easy_task_generator = EasyTaskGenerator.new
hard_task_generator = HardTaskGenerator.new
html_generator = HtmlGenerator.new "index.html"
for i in 1..12
	tasks << hard_task_generator.generate_task(i)
end	
html_generator.generate_html(tasks)


