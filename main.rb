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

	attr_accessor :number

	def initialize(number)
		@number = number
	end

	def generate_html_test(tasks)
		builder = Nokogiri::HTML::Builder.new do |doc|

		doc.html {
			doc.head {
				doc.title {
					doc.text "TEST #{number}"
				}
				doc.link(:rel => 'stylesheet', :type => 'text/css', :href => './style.css')
			}
			doc.body {
				task_number = 1
				doc.table {
					tasks.each_slice(2) do |slice|
						doc.tr {
							slice.each do |data|
								doc.td {
									doc.b.task_number {
										doc.text task_number
									}
									task_number += 1
									x = ""
									data.x.each_with_index do |current, index|
										x += index == 0 ? "#{current} = ?" : ", #{current} = ?"
									end
									doc.b.x {
										doc.text x
									}
									doc.br
									doc.code {
										data.body.each_char do |i|
											doc.text i
											if i == ';' or i == '{' or i == '}'
												doc.br
											end		
										end
									}
								}
							end
						}
					end
				}
			}
		}
		end
		File.open("Test#{number}.html", "w") { |file| file.write(builder.to_html) }
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
html_generator = HtmlGenerator.new 1
for i in 1..12
	tasks << hard_task_generator.generate_task(i)
end
html_generator.generate_html_test(tasks)


