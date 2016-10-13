SHELL := /bin/bash
CC = gcc
CFLAGS = -std=gnu99 -Wall -g -pthread
OBJS = list.o threadpool.o main.o

.PHONY: all clean test

GIT_HOOKS := .git/hooks/pre-commit

all: $(GIT_HOOKS) sort

$(GIT_HOOKS):
	@scripts/install-git-hooks
	@echo

deps := $(OBJS:%.o=.%.o.d)
%.o: %.c
	$(CC) $(CFLAGS) -o $@ -MMD -MF .$@.d -c $<

sort: $(OBJS)
	$(CC) $(CFLAGS) -o $@ $(OBJS) -rdynamic


UNSORTED = dic/random_test.txt
RESULT = dic/result.txt

RAN_NUM = 350000

random: sort
	(for i in {1..$(RAN_NUM)}; do echo $$RANDOM; done) | ./sort 4 $(RAN_NUM)

mutrace: sort
	(for i in {1..$(RAN_NUM)}; do echo $$RANDOM; done) | mutrace ./sort 4 $(RAN_NUM)

result_check:
	diff $(RESULT)  <(sort $(UNSORTED) )

clean:
	rm -f $(OBJS) sort
	@rm -rf $(deps)

-include $(deps)
