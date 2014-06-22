class Task
	attr_accessor :x
	attr_accessor :body

	def initialize(x, body)
		@x = x
		@body = body
	end
end

class EasyTaskGenerator
	def generate_task(number)
		case number
		when 1..2 
			x = "a"
			num = rand(15)
			body = "int orig = 0x#{(num*(16**3) + num).to_s(16)};\n"
			body +=	"int insert = 0x#{num.to_s(16)};\n"
			body +=	"int a = orig | (insert << #{rand(1..12)});"
		when 3..4
			x = "AND"
			num = rand(15)
			body = "int orig = 0x#{(num*(16**3) + num).to_s(16)};\n"
			body += "int insert = 0x#{num.to_s(16)};\n"
			body += "int a = orig | (insert << #{rand(1..12)});\n"
			body += "int b = orig | (insert << #{rand(1..12)});\n"
			body += "int AND = a & b;"
		when 5
			x = "XOR"
			num = rand(15)
			body = "int orig = 0x#{(num*(16**3) + num).to_s(16)};\n"
			body += "int insert = 0x#{num.to_s(16)};\n"
			body += "int a = orig | (insert << #{rand(1..12)});\n"
			body += "int b = orig | (insert << #{rand(1..12)});\n"
			body += "int XOR = a ^ b;"
		when 6
			x = "left"
			num = rand(15)
			body = "int i = 0x#{(num*(16**3) + num).to_s(16)};\n"
			body += "int left = i | (1 << #{rand(1..12)});"
		when 7
			x = "result"
			num = rand(15)
			body = "long value1 = 0x#{(num*(16**7) + num*(16**6) + num*(16**3) + num*(16**2)).to_s(16)};\n"
			body += "long value2 = 0x#{(num*(16**7) + num*(16**4) + num*(16**3) + num).to_s(16)};\n"
			body += "int result = (value1 << #{rand(1..4)}) ^ (value2 >> #{rand(1..4)});"
		when 8
			x = "result"
			num = rand(15)
			body = "long value1 = #{rand(1..512)};\n"
			body += "long value2 = #{rand(1..512)};\n"
			body += "int result = (value1 << #{rand(1..4)}) ^ (value2 >> #{rand(1..4)});"
		when 9
			x = "a"
			num = rand(15)
			body = "long testValue = 0x#{(num*(16**7) + num*(16**6) + num*(16**3) + num*(16**2)).to_s(16)};"
			body += "a = 0;\n"
			body += "if (testValue & (1 << #{rand(1..4)}))\n"
			body += "{\na = 1;\n}\nelse\n{\na = 2;\n}"
		when 10
			x = "a"
			num = rand(15)
			body = "long testValue = 0x#{(num*(16**7) + num*(16**6) + num*(16**3) + num*(16**2)).to_s(16)};"
			body += "int a = 0;\n"
			body += "if (testValue & testValue ^ testValue | (1 << #{rand(1..4)}))\n"
			body += "{\na = 1;\n}\nelse\n{\na = 2;\n}"
		when 11
			x = "result"
			body = "int value1 = #{rand(1..512)};\n"
			body += "int value2 = #{rand(1..512)};\n"
			body += "int result = (value1 << #{rand(1..4)}) ^ (value2 >> #{rand(1..4)});"
		when 12
			x = "result"
			body = "int value1 = #{rand(1..4096)};\n"
			body += "int value2 = #{rand(1..4096)};\n"
			body += "int result = (value1 << #{rand(1..4)}) | (value2 >> #{rand(1..4)});"
		end
		Task.new(x, body)
	end
end

generator = EasyTaskGenerator.new
p generator.generate_task(12)
