int http(char cmd, char *arg){
  int i;
  char command[128];
  char response[64];

  switch(cmd){
    // Download file and invoke mkbin
    case 0:
      break;


    // Download file and display to all telnet clients
    case 1:
      strcpy(command, "~1(");
      for(i = 3; i < strlen(arg) + 3; i++){
          command[i] = arg[i-3];
      }
      command[strlen(arg) + 3] = ')';
      command[strlen(arg) + 4] = '\n';
      command[strlen(arg) + 5] = '\0';
      //strcat(command + 3, ")\n");
      printf(command);
      break;


    // Download file into esp8266's buffer and send status to Sol-1
    case 2:
      strcpy(command, "~2(");
      for(i = 3; i < strlen(arg) + 3; i++){
          command[i] = arg[i-3];
      }
      command[strlen(arg) + 3] = ')';
      command[strlen(arg) + 4] = '\n';
      command[strlen(arg) + 5] = '\0';
      //strcat(command + 3, ")\n");
      printf(command);
      gets(response); // Read status response.
      return atoi(response);


    // request downloaded file that is in the esp8266's buffer
    case 3:
      printf("~3\n"); // Command sent to ESP8266. ESP will wait 3 seconds before sending the file.
      break;


    // get file size
    case 4:
      strcpy(command, "~4(");
      for(i = 3; i < strlen(arg) + 3; i++){
        command[i] = arg[i-3];
      }
      command[strlen(arg) + 3] = ')';
      command[strlen(arg) + 4] = '\n';
      command[strlen(arg) + 5] = '\0';
      //strcat(command + 3, ")\n");
      printf(command);
      break;

    default:

  }
}