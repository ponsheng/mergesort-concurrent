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


SORTED = dic/words_test.txt
RESULT = dic/random_test.txt

result_check:
	diff $(SORTED)  <(sort $(RESULT) )

clean:
	rm -f $(OBJS) sort
	@rm -rf $(deps)

-include $(deps)
