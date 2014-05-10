class CommentsController < ApplicationController

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user

    authorize @comment
    if @comment.save
      redirect_to [@post.topic, @post], notice: "Comment was saved successfully."
    else
      flash[:error] = "There was an error saving the comment. Please try again."
      #render :new
      redirect_to [@post.topic, @post]
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end