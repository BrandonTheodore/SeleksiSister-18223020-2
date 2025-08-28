IDENTIFICATION DIVISION.
       PROGRAM-ID. BANKING.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IN-FILE ASSIGN TO "input.txt".
           SELECT ACC-FILE ASSIGN TO "accounts.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT TMP-FILE ASSIGN TO "temp.txt"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT OUT-FILE ASSIGN TO "output.txt"
               ORGANIZATION IS LINE SEQUENTIAL.

       DATA DIVISION.
       FILE SECTION.

       FD IN-FILE.
       01 IN-RECORD.
           05 IN-ACCOUNT      PIC 9(6).
           05 IN-ACTION       PIC X(3).
           05 IN-AMOUNT-STR   PIC X(9).

       FD ACC-FILE.
       01 ACC-RECORD-RAW.
           05 ACC-ACCOUNT     PIC 9(6).
           05 FILLER          PIC X(3).
           05 ACC-BALANCE     PIC 9(6)V99.

       FD TMP-FILE.
       01 TMP-RECORD          PIC X(20).

       FD OUT-FILE.
       01 OUT-RECORD          PIC X(80).

       WORKING-STORAGE SECTION.
       77 IN-AMOUNT             PIC 9(6)V99.
       77 NEW-BALANCE           PIC 9(6)V99.
       77 MATCH-FOUND           PIC X VALUE "N".
       77 UPDATED               PIC X VALUE "N".

       01 RECORD-LAYOUT.
           05 REC-ACCOUNT        PIC 9(6).
           05 FILLER             PIC X(3) VALUE "   ".
           05 REC-BALANCE-NUM    PIC 9(6)V99.

       77 BALANCE-TEXT          PIC X(10) VALUE "BALANCE: ".
       77 FORMATTED-BALANCE     PIC Z(6).99.

       PROCEDURE DIVISION.
       MAIN.
           PERFORM INITIALIZE-FILES.
           PERFORM READ-INPUT.
           PERFORM PROCESS-RECORDS.
           PERFORM FINALIZE.
           STOP RUN.

       INITIALIZE-FILES.
           OPEN OUTPUT OUT-FILE.
           CLOSE OUT-FILE.
           OPEN OUTPUT TMP-FILE.
           CLOSE TMP-FILE.

       READ-INPUT.
           OPEN INPUT IN-FILE.
           READ IN-FILE AT END
               DISPLAY "INPUT FILE IS EMPTY"
               STOP RUN
           END-READ.
           CLOSE IN-FILE.
           MOVE FUNCTION NUMVAL(IN-AMOUNT-STR) TO IN-AMOUNT.
           MOVE FUNCTION UPPER-CASE(IN-ACTION) TO IN-ACTION.

       PROCESS-RECORDS.
           OPEN INPUT ACC-FILE.
           OPEN OUTPUT TMP-FILE.
           PERFORM UNTIL EXIT
               READ ACC-FILE
                   AT END
                       EXIT PERFORM
                   NOT AT END
                       IF ACC-ACCOUNT = IN-ACCOUNT
                           MOVE "Y" TO MATCH-FOUND
                           PERFORM APPLY-ACTION
                           MOVE NEW-BALANCE TO REC-BALANCE-NUM
                           MOVE ACC-ACCOUNT TO REC-ACCOUNT
                           WRITE TMP-RECORD FROM RECORD-LAYOUT
                       ELSE
                           WRITE TMP-RECORD FROM ACC-RECORD-RAW
                       END-IF
           END-PERFORM.
           CLOSE ACC-FILE.
           CLOSE TMP-FILE.

           IF MATCH-FOUND = "N" AND IN-ACTION = "NEW"
               PERFORM APPEND-ACCOUNT
           ELSE IF MATCH-FOUND = "N"
               MOVE "ERROR: ACCOUNT NOT FOUND" TO OUT-RECORD
               PERFORM WRITE-OUTPUT
           END-IF.

       APPLY-ACTION.
           MOVE "Y" TO UPDATED.
           MOVE ACC-BALANCE TO NEW-BALANCE.
           EVALUATE IN-ACTION
               WHEN "DEP"
                   ADD IN-AMOUNT TO NEW-BALANCE
                   MOVE "SUCCESS: DEPOSIT COMPLETE" TO OUT-RECORD
               WHEN "WDR"
                   IF NEW-BALANCE >= IN-AMOUNT
                       SUBTRACT IN-AMOUNT FROM NEW-BALANCE
                       MOVE "SUCCESS: WITHDRAWAL COMPLETE" TO OUT-RECORD
                   ELSE
                       MOVE "ERROR: INSUFFICIENT FUNDS" TO OUT-RECORD
                   END-IF
               WHEN "BAL"
                   MOVE ACC-BALANCE TO FORMATTED-BALANCE
                   STRING BALANCE-TEXT, FORMATTED-BALANCE
                       DELIMITED BY SIZE INTO OUT-RECORD
               WHEN OTHER
                   MOVE "ERROR: UNKNOWN ACTION" TO OUT-RECORD
           END-EVALUATE.
           PERFORM WRITE-OUTPUT.

       APPEND-ACCOUNT.
           OPEN EXTEND ACC-FILE.
           MOVE IN-ACCOUNT TO REC-ACCOUNT.
           MOVE IN-AMOUNT TO REC-BALANCE-NUM.
           WRITE ACC-RECORD-RAW FROM RECORD-LAYOUT.
           CLOSE ACC-FILE.
           MOVE "SUCCESS: ACCOUNT CREATED" TO OUT-RECORD.
           PERFORM WRITE-OUTPUT.

       FINALIZE.
           IF UPDATED = "Y"
               CALL "SYSTEM" USING "mv temp.txt accounts.txt"
           END-IF.

       WRITE-OUTPUT.
           OPEN OUTPUT OUT-FILE.
           WRITE OUT-RECORD.
           CLOSE OUT-FILE.