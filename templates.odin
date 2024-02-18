package main

run_batch_pre := "@ECHO OFF\nodin run . -file -out:./bin/"
run_batch_file := "%v"
run_batch_post := ".exe -debug -vet -strict-style -show-timings"

build_batch_pre := "@ECHO OFF\nodin build . -file -out:./bin/"
build_batch_file := "%v"
build_batch_post := ".exe -debug -vet -strict-style -show-timings"

clean_batch :=
	"@ECHO OFF\n" +
	"del .\\*.ilk .\\*.obj .\\*.pdb .\\*.exe .\\*.dll\n" +
	"del .\\build\\*.ilk .\\build\\*.obj .\\build\\*.pdb .\\build\\*.exe .\\build\\*.lib .\\build\\*.dll .\\build\\*.exp\n"

launch_json_pre :=
	"{" +
	"\"version\": \"0.2.0\"," +
	"\"configurations\": [" +
	"{" +
	"\"name\": \"Odin Debug\"," +
	"\"type\": \"cppvsdbg\"," +
	"\"request\": \"launch\"," +
	"\"program\": \""

launch_json_command := "./bin/%v.exe"
launch_json_post :=
	"\"," +
	"\"args\": []," +
	"\"stopAtEntry\": false, " +
	"\"cwd\": \"${workspaceFolder}\", " +
	"\"environment\": [], " +
	"\"preLaunchTask\": \"build\" " +
	"}" +
	"]" +
	"}"

settings_json :=
	"{" +
	"\"editor.defaultFormatter\": \"DanielGavin.ols\"," +
	"\"editor.formatOnSave\": true" +
	"}"

tasks_json :=
	"{" +
	"\"version\": \"2.0.0\"," +
	"\"tasks\": [" +
	"{" +
	"\"label\": \"build\"," +
	"\"type\": \"shell\"," +
	"\"command\": \"./build.bat\"," +
	"\"group\": {" +
	"\"kind\": \"build\"," +
	"\"isDefault\": true" +
	"}," +
	"\"problemMatcher\": [\"$gcc\"]" +
	"}" +
	"]" +
	"}"

ols_json :=
	"{" +
	"\"collections\": [" +
	"{" +
	"\"name\": \"core\"," +
	"\"path\": \"C:\\\\programming\\\\odin\\\\Odin\\\\core\"" +
	"}," +
	"{" +
	"\"name\": \"vendor\"," +
	"\"path\": \"C:\\\\programming\\\\odin\\\\Odin\\\\vendor\"" +
	"}" +
	"]," +
	"\"enable_document_symbols\": true, " +
	"\"enable_semantic_tokens\": true, " +
	"\"enable_inlay_hints\": true, " +
	"\"enable_procedure_snippet\": true, " +
	"\"enable_hover\": true, " +
	"\"enable_snippets\": true, " +
	"\"enable_format\": true, " +
	"\"formatter\": { " +
	"\"tabs\": true, " +
	"\"tabs_width\": 4, " +
	"\"character_width\": 80 " +
	"}" +
	"}"

odinfmt_json :=
	"{" +
	"\"$schema\": \"https://raw.githubusercontent.com/DanielGavin/ols/master/misc/odinfmt.schema.json\"," +
	"\"character_width\": 80," +
	"\"tabs\": true, " +
	"\"tabs_width\": 4 " +
	"}"

main_lines := []string {
	"package main\n",
	"\n",
	"import \"core:fmt\"\n",
	"\n",
	"main :: proc() {\n",
	"\tfmt.println(\"[odin-init] Hello from the otherside\")\n",
	"}",
}
