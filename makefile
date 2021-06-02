.SUFFIXES: .erl .beam

.erl.beam:
	erlc -Wall $<

ERL = erl -boot start_clean

MODS = matrix

all: compile run

compile: ${MODS:%=%.beam}

run:
	${ERL} -s matrix start

oneoff: compile
	${ERL} -noshell -s matrix start -s init stop

clean:
	rm -rf *.beam erl_crash.dump