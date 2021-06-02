.SUFFIXES: .erl .beam

.erl.beam:
	erlc -Wall $<

ERL = erl -boot start_clean

MODS = matrix

all: compile run

compile: ${MODS:%=%.beam}

run:
	${ERL} -noshell -s matrix start -s init stop

shell: compile
	${ERL} -s matrix start -s

clean:
	rm -rf *.beam erl_crash.dump