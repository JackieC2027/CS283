## Assignment 2 Questions

#### Directions
Please answer the following questions and submit in your repo for the second assignment.  Please keep the answers as short and concise as possible.

1. In this assignment I asked you provide an implementation for the `get_student(...)` function because I think it improves the overall design of the database application.   After you implemented your solution do you agree that externalizing `get_student(...)` into it's own function is a good design strategy?  Briefly describe why or why not.

    > **Answer**: I would agree that externalizing the get_student(...) function proves to be good design for the database application because it allows these functions to be reused in different applications. From an database perspective, if we wanted to delete a student from the database, we would need to find the student first and then proceed to delete them. get_student can be used here, which ulimately increases the resuability of the code.

2. Another interesting aspect of the `get_student(...)` function is how its function prototype requires the caller to provide the storage for the `student_t` structure:

    ```c
    int get_student(int fd, int id, student_t *s);
    ```

    Notice that the last parameter is a pointer to storage **provided by the caller** to be used by this function to populate information about the desired student that is queried from the database file. This is a common convention (called pass-by-reference) in the `C` programming language. 

    In other programming languages an approach like the one shown below would be more idiomatic for creating a function like `get_student()` (specifically the storage is provided by the `get_student(...)` function itself):

    ```c
    //Lookup student from the database
    // IF FOUND: return pointer to student data
    // IF NOT FOUND: return NULL
    student_t *get_student(int fd, int id){
        student_t student;
        bool student_found = false;
        
        //code that looks for the student and if
        //found populates the student structure
        //The found_student variable will be set
        //to true if the student is in the database
        //or false otherwise.

        if (student_found)
            return &student;
        else
            return NULL;
    }
    ```
    Can you think of any reason why the above implementation would be a **very bad idea** using the C programming language?  Specifically, address why the above code introduces a subtle bug that could be hard to identify at runtime? 

    > **ANSWER:** It would be a terrible idea to use this implmentation of the get_student() function in Clang because the returned reference to the student is the memory address. Although this does represent the student entry in memory, student is a local variable, which happens to be stored on the stack and later become deallocated upon returning a value for the function. Since the address gets deallocated, there might be unwanted behaviors when other functions need to reference this student address, which is supposed to represent a student. As previously mentioned, this would be the case since get_student should be highly reusable.

3. Another way the `get_student(...)` function could be implemented is as follows:

    ```c
    //Lookup student from the database
    // IF FOUND: return pointer to student data
    // IF NOT FOUND or memory allocation error: return NULL
    student_t *get_student(int fd, int id){
        student_t *pstudent;
        bool student_found = false;

        pstudent = malloc(sizeof(student_t));
        if (pstudent == NULL)
            return NULL;
        
        //code that looks for the student and if
        //found populates the student structure
        //The found_student variable will be set
        //to true if the student is in the database
        //or false otherwise.

        if (student_found){
            return pstudent;
        }
        else {
            free(pstudent);
            return NULL;
        }
    }
    ```
    In this implementation the storage for the student record is allocated on the heap using `malloc()` and passed back to the caller when the function returns. What do you think about this alternative implementation of `get_student(...)`?  Address in your answer why it work work, but also think about any potential problems it could cause.  
    
    > **ANSWER:** Based off this alternative implementation of get_student(...), it is possible to use malloc, so that the reference to the student's entry persists after the function call, relieving the issue that was related to the previous apporach. This is because the memory is allocated off the heap, which does not get deallocated after the function returns a value. However, this actually complicates the function by incorporating direct memory management into the function. If we forget to free the memory that was allocated off of the heap for the corresponding student, this could lead to memory leaks, adding another unnecessary layer of complexion. 


4. Lets take a look at how storage is managed for our simple database. Recall that all student records are stored on disk using the layout of the `student_t` structure (which has a size of 64 bytes).  Lets start with a fresh database by deleting the `student.db` file using the command `rm ./student.db`.  Now that we have an empty database lets add a few students and see what is happening under the covers.  Consider the following sequence of commands:

    ```bash
    > ./sdbsc -a 1 john doe 345
    > ls -l ./student.db
        -rw-r----- 1 bsm23 bsm23 128 Jan 17 10:01 ./student.db
    > du -h ./student.db
        4.0K    ./student.db
    > ./sdbsc -a 3 jane doe 390
    > ls -l ./student.db
        -rw-r----- 1 bsm23 bsm23 256 Jan 17 10:02 ./student.db
    > du -h ./student.db
        4.0K    ./student.db
    > ./sdbsc -a 63 jim doe 285 
    > du -h ./student.db
        4.0K    ./student.db
    > ./sdbsc -a 64 janet doe 310
    > du -h ./student.db
        8.0K    ./student.db
    > ls -l ./student.db
        -rw-r----- 1 bsm23 bsm23 4160 Jan 17 10:03 ./student.db
    ```

    For this question I am asking you to perform some online research to investigate why there is a difference between the size of the file reported by the `ls` command and the actual storage used on the disk reported by the `du` command.  Understanding why this happens by design is important since all good systems programmers need to understand things like how linux creates sparse files, and how linux physically stores data on disk using fixed block sizes.  Some good google searches to get you started: _"lseek syscall holes and sparse files"_, and _"linux file system blocks"_.  After you do some research please answer the following:

    - Please explain why the file size reported by the `ls` command was 128 bytes after adding student with ID=1, 256 after adding student with ID=3, and 4160 after adding the student with ID=64? 

        > **ANSWER:** The reason that the file size reported by the ls command was as recored can be explained by the number of bytes that each student record takes. Each student record takes up 64 bytes, where the IDs are represenative of the position in the database. For a student with the ID=1, it makes sense that there needs to be 2 spaces in memory that need to be referenced for this specific ID, which can be shown by (n * 64), where n represents the spaces from 0 that the ID correspondins to. Proceedingly, the student with the ID=3 would need memory slots of 0-3 inclsuive, which can be computed by doing 4 * 64 = 256. For the ID=64, there will need to be 64 spaces from 0 to position this student entry, leading to the calcualted 4160 bytes (65 * 64).

    -   Why did the total storage used on the disk remain unchanged when we added the student with ID=1, ID=3, and ID=63, but increased from 4K to 8K when we added the student with ID=64? 

        > **ANSWER:** The total storage was unchanged for the student with the IDs: 1, 3, and 63, whereas the total storage increased for ID=64 because of the support of sparce files within Linux. With a fixed-amount of 4k bytes that the students, in this case, the students will be able to fit into the allocated block of bytes without increasing the size of the storage. However, since the last student with ID=64 will not fit into this 4k block on the disk storage, new memory is needed to write the bytes, which forces the system to increase the actual storage used to 8k.

    - Now lets add one more student with a large student ID number  and see what happens:

        ```bash
        > ./sdbsc -a 99999 big dude 205 
        > ls -l ./student.db
        -rw-r----- 1 bsm23 bsm23 6400000 Jan 17 10:28 ./student.db
        > du -h ./student.db
        12K     ./student.db
        ```
        We see from above adding a student with a very large student ID (ID=99999) increased the file size to 6400000 as shown by `ls` but the raw storage only increased to 12K as reported by `du`.  Can provide some insight into why this happened?

        > **ANSWER:** When creating a student with the ID=99999, the sparce file that is created will need to contain enough space for 0-99999 slots, as this was the calculation that needed to be accounted for empty space between student entries in the database, hence explaining the file size of 6400000. Since there are not students filling the space for the designated ID, the disk storage size only has to increase to allow this ID to properly fit within the block because of the utilziation of sparce files in Linux. Whenever there are empty blocks, zeros will appear in the database file being read, which means the raw storage shown represents the necessary storage to store the physical data, not all possible instances of the physical data, which happens to be 12k.