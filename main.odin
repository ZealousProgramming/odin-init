/*
		MIT License

		Copyright (c) 2024 Devon "ZealousProgramming" McKenzie

		Permission is hereby granted, free of charge, to any person obtaining a copy
		of this software and associated documentation files (the "Software"), to deal
		in the Software without restriction, including without limitation the rights
		to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
		copies of the Software, and to permit persons to whom the Software is
		furnished to do so, subject to the following conditions:

		The above copyright notice and this permission notice shall be included in all
		copies or substantial portions of the Software.

		THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
		IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
		FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
		AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
		LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
		OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
		SOFTWARE.
*/

package main

import "core:fmt"
import "core:os"
import "core:strings"

VERSION_MAJOR := 1
VERSION_MINOR := 1
VERSION_PATCH := 0

main :: proc() {
	context.allocator = context.temp_allocator
	current_directory := os.get_current_directory()
	fmt.printf("%v", current_directory)

	buffer: [1024]byte

	fmt.println(
		"[odin-init] Version v%v.%v.%v",
		VERSION_MAJOR,
		VERSION_MINOR,
		VERSION_PATCH,
	)
	fmt.print("[odin-init] Project name: ")
	project_name := handle_input(buffer[:])

	directory_create("./bin")
	setup_vscode_settings(project_name)
	setup_odin_files()
	setup_batch_scripts(project_name)

	fmt.printf("[odin-init] Setup for %v completed..\n", project_name)
}

/* 
Setup `settings.json`, `tasks.json`, and `launch.json` inside of 
`.vscode` directory.*/
@(private = "file")
setup_vscode_settings :: proc(project_name: string) {
	directory_create("./.vscode")
	file_write_string(
		"./.vscode/launch.json",
		strings.concatenate(
			[]string {
				launch_json_pre,
				fmt.tprintf(launch_json_command, project_name),
				launch_json_post,
			},
		),
	)
	file_write_string("./.vscode/settings.json", settings_json)
	file_write_string("./.vscode/tasks.json", tasks_json)
}

/*
Create default `ols.json`, `odinfmt.json`, and `main.odin` file
*/
@(private = "file")
setup_odin_files :: proc() {
	file_write_string("./ols.json", ols_json)
	file_write_string("./odinfmt.json", odinfmt_json)
	make_odin_main()
}

@(private = "file")
make_odin_main :: proc() {
	if os.exists("./main.odin") {return}

	handle, err := os.open("./main.odin", os.O_CREATE)
	defer os.close(handle)

	fmt.assertf(err == 0, "FAILED TO CREATE MAIN.ODIN: successful = %v", err)

	for line in main_lines {
		bytes_written, err := os.write(handle, transmute([]u8)line)

		assert(err == 0)
	}
}


/*
Setups up standard .bat scripts, such as `build`, `run,` and `clean`
*/
@(private = "file")
setup_batch_scripts :: proc(project_name: string) {
	file_write_string(
		"./build.bat",
		strings.concatenate(
			[]string {
				build_batch_pre,
				fmt.tprintf(build_batch_file, project_name),
				build_batch_post,
			},
		),
	)

	file_write_string(
		"./run.bat",
		strings.concatenate(
			[]string {
				run_batch_pre,
				fmt.tprintf(run_batch_file, project_name),
				run_batch_post,
			},
		),
	)

	file_write_string("./clean.bat", clean_batch)
}


// --- UTILITIES ---
// -----------------
@(private = "file")
file_write_string :: proc(filepath: string, data: string) {
	if os.exists(filepath) {return}

	success := os.write_entire_file(filepath, transmute([]u8)data)
	fmt.assertf(
		success == true,
		"FAILED TO CREATE %v: successful = %v",
		filepath,
		success,
	)
}

@(private = "file")
file_write_bytes :: proc(filepath: string, data: []u8) {
	if os.exists(filepath) {return}

	success := os.write_entire_file(filepath, data)
	fmt.assertf(
		success == true,
		"FAILED TO CREATE %v: successful = %v",
		filepath,
		success,
	)
}

@(private = "file")
directory_create :: proc(path: string) {
	if os.exists(path) {return}

	err := os.make_directory(path)
	fmt.assertf(err == 0, "FAILED TO CREATE DIRECTORY: %v", path)
}

@(private = "file")
handle_input :: proc(buffer: []byte) -> string {
	size, err := os.read(os.stdin, buffer)

	fmt.assertf(err == 0, "ERROR OCCURED: %v", err)

	// Trim the carriage return and line feed (13, 10)
	ending_idx := 0
	for b, idx in buffer {
		if b == 0 {continue}
		if b == 13 {
			ending_idx = idx
		}
	}

	result := string(buffer[0:ending_idx])

	return result
}
