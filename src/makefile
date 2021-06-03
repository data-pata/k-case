.SUFFIXES: .erl .beam

.erl.beam:
	erlc -Wall $<

ERL = erl -boot start_clean

MODS = matrix concmatrix worker concmatrix_tests

compile: ${MODS:%=%.beam}

conc: compile
	${ERL} -noshell -s concmatrix start -s init stop

seq: compile
	${ERL} -noshell -s matrix start -s init stop
	
shell: compile
	${ERL} -s matrix start
	${ERL} -s concmatrix start

test: compile
	${ERL} -s concmatrix_tests start

clean:
	rm -rf *.beam erl_crash.dump