class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:update, :edit]
  before_action :ensure_guest_user, only: [:edit]

  def show
    @user = User.find(params[:id])
    @books = @user.books
    @book = Book.new
    # ここからDM用
    # ログインユーザーと相手ユーザーの情報をEntryテーブルから取得
    @current_entry = Entry.where(user_id: current_user.id)
    @another_entry = Entry.where(user_id: @user.id)
    # 別ユーザーのページならば、同じルームIDがあるか検索
    unless @user.id == current_user.id
      @current_entry.each do |current|
        @another_entry.each do |another|
          if current.room_id == another.room_id
            # 同じルームIDがあればtrueである事とルームIDを渡す
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      # IDが存在しない場合は新しくインスタンスを作成
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
    # ここまでDM用
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = current_user
  end

  def update
    @books = Book.all
    if @user.update(user_params)
      redirect_to user_path(@user), notice: "You have updated user successfully."
    else
      render :edit
    end
  end

  def followings
    user = User.find(params[:id])
    @users = user.followings #userに結びついているフォロー全員を取得
  end

  def followers
    user = User.find(params[:id])
    @users = user.followers #userに結びついているフォロワー全員を取得
  end

  private
    def user_params
      params.require(:user).permit(:name, :introduction, :profile_image)
    end

    def ensure_correct_user
      @user = User.find(params[:id])
      unless @user == current_user
        redirect_to user_path(current_user)
      end
    end

    def ensure_guest_user
      @user = User.find(params[:id])
      if @user.name == "guestuser"
        redirect_to user_path(current_user), notice: "ゲストユーザーはプロフィール編集画面に遷移できません。"
      end
    end
end
