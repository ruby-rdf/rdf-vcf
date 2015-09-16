all: build

build: Rakefile
	jruby -S bundle exec rake build

check: Rakefile
	jruby -S bundle exec rake spec

install: build
	jruby -S bundle exec rake install

clean:
	rm -f *~ *.gem

.PHONY: build check install clean
