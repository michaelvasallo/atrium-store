ActiveAdmin.register Game do
  config.sort_order = 'title_asc'

  permit_params :title, :description, :price, :discount, :release_date, :image, :video, :developer_id, :publisher_id, genre_ids: []

  controller do
    def find_resource
      scoped_collection.friendly.find(params[:id])
    end
  end

  index do
    selectable_column
    id_column
    column :title
    column :price
    column :discount
    column :release_date
    column :developer
    column :publisher
    column :created_at
    column :updated_at
    actions
  end

  index as: :grid do |game|
    link_to image_tag(game.image), admin_game_path(game)
  end

  show do
    attributes_table do
      row :image do |game|
        image_tag game.image
      end
      row :title
      row :description
      row :price
      row :discount
      row :release_date
      row :video
      row :developer
      row :publisher
      row :genres do |game|
        game.print_genres
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :image, as: :file, hint: image_tag(f.object.image)
      f.input :title
      f.input :description
      f.input :price
      f.input :discount
      f.input :release_date
      f.input :video
      f.input :developer
      f.input :publisher
      f.input :genre_ids, label: 'Genres', as: :check_boxes, collection: Genre.all
    end
    f.actions
  end
end
