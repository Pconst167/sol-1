#include <gtk/gtk.h>

// Function to create a checkbox
GtkWidget *create_checkbox(const gchar *label) {
    GtkWidget *check_button;
    check_button = gtk_check_button_new_with_label(label);
    return check_button;
}

// Function to create combo box
GtkWidget *create_combo_box(const gchar *items[], int n_items) {
    GtkWidget *combo_box = gtk_combo_box_text_new();
    for (int i = 0; i < n_items; i++) {
        gtk_combo_box_text_append_text(GTK_COMBO_BOX_TEXT(combo_box), items[i]);
    }
    return combo_box;
}

// Function to create list box
GtkWidget *create_list_box(int n_items) {
    GtkWidget *list_box = gtk_list_box_new();
    for (int i = 0; i < n_items; i++) {
        gchar *item_text = g_strdup_printf("Item %d", i);
        GtkWidget *row = gtk_list_box_row_new();
        GtkWidget *label = gtk_label_new(item_text);
        gtk_container_add(GTK_CONTAINER(row), label);
        gtk_list_box_insert(GTK_LIST_BOX(list_box), row, -1);
        g_free(item_text);
    }
    return list_box;
}

// Function to create a multi-column list box
GtkWidget *create_multi_column_list_box(int n_items, int columns) {
    GtkWidget *box = gtk_box_new(GTK_ORIENTATION_HORIZONTAL, 5);
    for (int col = 0; col < columns; col++) {
        GtkWidget *list_box = gtk_list_box_new();
        gtk_box_pack_start(GTK_BOX(box), list_box, TRUE, TRUE, 5);
        for (int i = col; i < n_items; i += columns) {
            gchar *item_text = g_strdup_printf("Item %d", i);
            GtkWidget *row = gtk_list_box_row_new();
            GtkWidget *label = gtk_label_new(item_text);
            gtk_container_add(GTK_CONTAINER(row), label);
            gtk_list_box_insert(GTK_LIST_BOX(list_box), row, -1);
            g_free(item_text);
        }
    }
    return box;
}

void activate(GtkApplication *app, gpointer user_data) {
    GtkWidget *window;
    GtkWidget *grid;
    GtkWidget *menu_bar;
    GtkWidget *menu;
    GtkWidget *menu_item;
    GtkWidget *label;
    GtkWidget *scrolled_window;
    GtkWidget *text_view;
    GtkWidget *left_panel;
    GtkWidget *center_left_panel;
    GtkWidget *bottom_center_left_panel;
    GtkWidget *center_panel;
    GtkWidget *right_panel;
    GtkWidget *check_button;

    window = gtk_application_window_new(app);
    gtk_window_set_title(GTK_WINDOW(window), "GTK Application");
    gtk_window_set_default_size(GTK_WINDOW(window), 1200, 800);

    // Main grid layout
    grid = gtk_grid_new();
    gtk_container_add(GTK_CONTAINER(window), grid);

    // Menu bar
    menu_bar = gtk_menu_bar_new();
    menu = gtk_menu_new();

    menu_item = gtk_menu_item_new_with_label("File");
    gtk_menu_item_set_submenu(GTK_MENU_ITEM(menu_item), menu);
    gtk_menu_shell_append(GTK_MENU_SHELL(menu_bar), menu_item);

    menu_item = gtk_menu_item_new_with_label("New");
    gtk_menu_shell_append(GTK_MENU_SHELL(menu), menu_item);

    menu_item = gtk_menu_item_new_with_label("Open");
    gtk_menu_shell_append(GTK_MENU_SHELL(menu), menu_item);

    menu_item = gtk_menu_item_new_with_label("Save");
    gtk_menu_shell_append(GTK_MENU_SHELL(menu), menu_item);

    gtk_grid_attach(GTK_GRID(grid), menu_bar, 0, 0, 4, 1);

    // Left panel
    left_panel = gtk_grid_new();
    gtk_widget_set_size_request(left_panel, 200, -1); // Set width
    gtk_grid_attach(GTK_GRID(grid), left_panel, 0, 1, 1, 2);

    const gchar *combo_items[] = {"Option 1", "Option 2", "Option 3"};
    label = gtk_label_new("Next Micro-Instruction:");
    gtk_grid_attach(GTK_GRID(left_panel), label, 0, 0, 1, 1);
    GtkWidget *combo_box = create_combo_box(combo_items, 3);
    gtk_grid_attach(GTK_GRID(left_panel), combo_box, 1, 0, 1, 1);

    label = gtk_label_new("Copy Instruction:");
    gtk_grid_attach(GTK_GRID(left_panel), label, 0, 1, 1, 1);
    combo_box = create_combo_box(combo_items, 3);
    gtk_grid_attach(GTK_GRID(left_panel), combo_box, 1, 1, 1, 1);

    // Center-left panel (checkboxes)
    center_left_panel = gtk_grid_new();
    gtk_widget_set_size_request(center_left_panel, 100, -1); // Set width
    gtk_grid_attach(GTK_GRID(grid), center_left_panel, 1, 1, 1, 1);

    for (int i = 0; i < 10; i++) { // Example number of checkboxes
        gchar *label_text = g_strdup_printf("Checkbox %d", i);
        check_button = create_checkbox(label_text);
        gtk_grid_attach(GTK_GRID(center_left_panel), check_button, i % 3, i / 3, 1, 1);
        g_free(label_text);
    }

    // Bottom center-left panel (large textbox)
    bottom_center_left_panel = gtk_grid_new();
    gtk_widget_set_size_request(bottom_center_left_panel, 100, -1); // Set width
    gtk_grid_attach(GTK_GRID(grid), bottom_center_left_panel, 1, 2, 1, 1);

    scrolled_window = gtk_scrolled_window_new(NULL, NULL);
    gtk_widget_set_vexpand(scrolled_window, TRUE);
    gtk_widget_set_hexpand(scrolled_window, TRUE);
    gtk_grid_attach(GTK_GRID(bottom_center_left_panel), scrolled_window, 0, 0, 3, 1);

    text_view = gtk_text_view_new();
    gtk_container_add(GTK_CONTAINER(scrolled_window), text_view);

    // Center panel (list box with 64 items)
    center_panel = gtk_grid_new();
    gtk_widget_set_size_request(center_panel, 100, -1); // Set width
    gtk_grid_attach(GTK_GRID(grid), center_panel, 2, 1, 1, 2);

    scrolled_window = gtk_scrolled_window_new(NULL, NULL);
    gtk_widget_set_vexpand(scrolled_window, TRUE);
    gtk_widget_set_hexpand(scrolled_window, TRUE);
    gtk_grid_attach(GTK_GRID(center_panel), scrolled_window, 0, 0, 1, 1);

    GtkWidget *center_list_box = create_list_box(64);
    gtk_container_add(GTK_CONTAINER(scrolled_window), center_list_box);

    // Right panel (list box with 256 items, 4 columns)
    right_panel = gtk_grid_new();
    gtk_widget_set_size_request(right_panel, 400, -1); // Set width
    gtk_grid_attach(GTK_GRID(grid), right_panel, 3, 1, 1, 2);

    scrolled_window = gtk_scrolled_window_new(NULL, NULL);
    gtk_widget_set_vexpand(scrolled_window, TRUE);
    gtk_widget_set_hexpand(scrolled_window, TRUE);
    gtk_grid_attach(GTK_GRID(right_panel), scrolled_window, 0, 0, 1, 1);

    GtkWidget *right_multi_column_list_box = create_multi_column_list_box(256, 4);
    gtk_container_add(GTK_CONTAINER(scrolled_window), right_multi_column_list_box);

    gtk_widget_show_all(window);
}

int main(int argc, char **argv) {
    GtkApplication *app;
    int status;

    app = gtk_application_new("org.gtk.example", G_APPLICATION_DEFAULT_FLAGS);
    g_signal_connect(app, "activate", G_CALLBACK(activate), NULL);
    status = g_application_run(G_APPLICATION(app), argc, argv);
    g_object_unref(app);

    return status;
}
