#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "dshlib.h"
#include <stdio.h>
/*
 *  build_cmd_list
 *    cmd_line:     the command line from the user
 *    clist *:      pointer to clist structure to be populated
 *
 *  This function builds the command_list_t structure passed by the caller
 *  It does this by first splitting the cmd_line into commands by splitting
 *  the string based on any pipe characters '|'. It then traverses each
 *  command. For each command (a substring of cmd_line), it then parses
 *  that command by taking the first token as the executable name, and
 *  then the remaining tokens as the arguments.
 *
 *  errors returned:
 *
 *    OK:                      No Error
 *    ERR_TOO_MANY_COMMANDS:   There is a limit of CMD_MAX (see dshlib.h)
 *                             commands.
 *    ERR_CMD_OR_ARGS_TOO_BIG: One of the commands provided by the user
 *                             was larger than allowed, either the
 *                             executable name, or the arg string.
 *
 *  Standard Library Functions You Might Want To Consider Using
 *      memset(), strcmp(), strcpy(), strtok(), strlen(), strchr()
 */
int build_cmd_list(char *cmd_line, command_list_t *clist){
    memset(clist, 0, sizeof(command_list_t));
    char *eachPipedCommand = strtok(cmd_line, PIPE_STRING);
    int numberOfCommands = 0;
    if (strlen(cmd_line) == 0){
        return WARN_NO_CMDS;
    }
    while (eachPipedCommand != NULL){
        if(numberOfCommands >= CMD_MAX){
            return ERR_TOO_MANY_COMMANDS;
        }
        while(*eachPipedCommand == SPACE_CHAR){
            eachPipedCommand++;
        }
        if(strlen(eachPipedCommand) == 0){
            eachPipedCommand = strtok(NULL, PIPE_STRING);
            continue;
        }
        if (strlen(eachPipedCommand) >= EXE_MAX){
            return ERR_CMD_OR_ARGS_TOO_BIG;
        }
        char *commandExecutableWhitespace = strchr(eachPipedCommand, SPACE_CHAR);
        if(commandExecutableWhitespace != NULL){
            int commandExecutableNameLength = commandExecutableWhitespace - eachPipedCommand;
            if(commandExecutableNameLength >= EXE_MAX){
                return ERR_CMD_OR_ARGS_TOO_BIG;
            }
            strncpy(clist->commands[numberOfCommands].exe, eachPipedCommand, commandExecutableNameLength);
            clist->commands[numberOfCommands].exe[commandExecutableNameLength] = '\0';
            commandExecutableWhitespace++;
            while(*commandExecutableWhitespace == SPACE_CHAR){
                commandExecutableWhitespace++;
            }
            strncpy(clist->commands[numberOfCommands].args, commandExecutableWhitespace, ARG_MAX - 1);
            clist->commands[numberOfCommands].args[ARG_MAX - 1] = '\0';
        }else{
            strncpy(clist->commands[numberOfCommands].exe, eachPipedCommand, EXE_MAX - 1);
            clist->commands[numberOfCommands].exe[EXE_MAX - 1] = '\0';
            clist->commands[numberOfCommands].args[0] = '\0';
        }
        numberOfCommands++;
        eachPipedCommand = strtok(NULL, PIPE_STRING);
    }
    clist->num = numberOfCommands;
    return OK;
}
