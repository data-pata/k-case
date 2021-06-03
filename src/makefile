.SUFFIXES: .erl .beam

.erl.beam:
	erlc -Wall $<

ERL = erl -boot start_clean

MODS = matrix concmatrix worker

compile: ${MODS:%=%.beam}

conc: compile
	${ERL} -noshell -s concmatrix start -s init stop

seq: compile
	${ERL} -noshell -s matrix start -s init stop
	
shell: compile
	${ERL} -s matrix start -s
	${ERL} -s concmatrix start

clean:
	rm -rf *.beam erl_crash.dump