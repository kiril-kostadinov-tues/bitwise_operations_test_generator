require "nokogiri"

class Task
	attr_accessor :x
	attr_accessor :body
	attr_accessor :answer

	def initialize(x, body)
		@x = x
		@body = body
		@answer = []
	end

	def get_answer
		`gcc test.c`
		`./a.out`.each_line do |line|
			@answer << [line.gsub("\n", ""), "0x#{line.to_i.to_s(16)}"]
		end
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

	def generate_html_answers(tasks)
		builder = Nokogiri::HTML::Builder.new do |doc|

		doc.html {
			doc.head {
				doc.title {
					doc.text "TEST #{number} ANSWERS"
				}
				doc.link(:rel => 'stylesheet', :type => 'text/css', :href => './style.css')
			}
			doc.body {
				task_number = 1
				tasks.each do |task|
					doc.b.task_number {
						doc.text task_number
					}
					task_number += 1
					task.answer.each_with_index do |answer, index|
						doc.text "#{task.x[index]} = #{answer[0]}, #{answer[1]}"
						doc.br
					end
				end
			}
		}
		end
		File.open("Test#{number}_answers.html", "w") { |file| file.write(builder.to_html) }
	end
end

class CFilesGenerator 

	attr_accessor :file_name

	def initialize(filename)
		@file_name = filename;
	end

	def generate_c_file(task)
		File.open(file_name, "w") do |file|
			file.write("#include<stdio.h>\n")
			file.write("\nint main() {\n")
			file.write(task.body)
			file.write("\n")
			task.x.each do |current_x|
				file.write("printf(\"\%d\\n\", #{current_x});\n")
			end
			file.write("return 0;\n}")
		end
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
		File.open("Templates/easyTask#{number}.txt").each_with_index do |line, index|
			if index == 0
				x = line.gsub("\n", "").split(',')
				next
			end
			body += line
		end
		num = rand(1..15)
		body = eval('"' + body + '"')
		Task.new(x, body)
	end
end

class HardTaskGenerator
	def generate_task(number)
		x = []
		body = ""
		File.open("Templates/hardTask#{number}.txt").each_with_index do |line, index|
			if index == 0
				x = line.gsub("\n", "").split(',')
				next
			end
			body += line
		end
		num = rand(1..15)
		body = eval('"' + body + '"')
		Task.new(x, body)
	end
end

generator = ARGV[1] == "2" ? HardTaskGenerator.new : EasyTaskGenerator.new
ARGV[0].nil? ? number_of_tests = 0 : number_of_tests = ARGV[0].to_i - 1
ARGV[2].nil? ? starting_test = 1 : starting_test = ARGV[2].to_i
c_file_generator = CFilesGenerator.new("test.c")

for i in starting_test..starting_test+number_of_tests
	tasks = []
	html_generator = HtmlGenerator.new(i)
	for j in 1..12
		tasks << generator.generate_task(j)
		c_file_generator.generate_c_file(tasks[j-1])
		tasks[j-1].get_answer
	end
	html_generator.generate_html_test(tasks)
	html_generator.generate_html_answers(tasks)
	`./Converter/wkhtmltopdf Test#{i}.html Test#{i}.pdf`
	`./Converter/wkhtmltopdf Test#{i}_answers.html Test#{i}_answers.pdf`
	puts "GENERATED TEST #{i}"
end

`rm -f ./a.out`
`rm -f ./test.c`
