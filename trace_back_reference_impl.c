int trace_back(u8* maze, int dest) {
    size_t current_index = dest;
    size_t step_count = maze[dest];

    main_loop:
        if (dest[current_index] == 1) return step_count;


        current_index = maybe_update_index(0, current_index, maze);
        current_index = maybe_update_index(1, current_index, maze);
        current_index = maybe_update_index(2, current_index, maze);
        current_index = maybe_update_index(3, current_index, maze);

        maze[current_index] = 244;
        goto main_loop;
}

u8 maybe_update_index(u8 direction, u8 current_index, u8* maze) {
    u8 neighbor = neighor(direction, current_index) == -1;
    if (neighor == -1)  return current_index;
    if (maze[neighor] < maze[current_index]) return neighor;
}
