int trace_back(u8* maze, int dest) {
    size_t current_index = dest;
    size_t step_count = maze[dest];

    main_loop:

        if (dest[current_index] == 1) return step_count;

        // check neighbor left
        size_t left = neighbor(0);
        if (!wall_or_border(current_index, left)) {
            current_index = left;
        }
        size_t right = neighbor(1);
        if (!wall_or_border(current_index, right)) {
            current_index = right;
        }
        size_t up = neighbor(2);
        if (!wall_or_border(current_index, up)) {
            current_index = up;
        }
        size_t down = neighbor(3);
        if (!wall_or_border(current_index, down)) {
            current_index = down;
        }

        maze[current_index] = 244;
        goto main_loop;
}
