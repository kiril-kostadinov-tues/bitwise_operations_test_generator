Bitwise Operations Test Generator
=================================

Run the script as
```
ruby main.rb <number_of_tests> <difficulty> <number_of_first_test>
```

Default value for number_of_tests is 1.
Passing 1 to script means easy difficulty, while 2 is hard difficulty. Default value is easy.
The script generates files called Test<number> and Test<number>_answers. If you want to start naming the files from a specific number, pass it to number_of_first_test. Default value is 1.


The script uses templates to generate different types of tasks. You can modify these templates and have the script fill it with numbers for you.
You can use the functions dec_length(length), dec_range(low..high), hex_length(length), hex_range(low..high). The script also generates a random hex digit (1 to f) in the variable num, which you can use for generation of easier tasks.
