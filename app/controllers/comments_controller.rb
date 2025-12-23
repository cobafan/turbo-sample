class CommentsController < ApplicationController
  before_action :set_todo
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @todo.comments.build(comment_params)

    respond_to do |format|
      if @comment.save
        format.html { redirect_to @todo, notice: "Comment was successfully created." }
        format.turbo_stream
      else
        format.html { redirect_to @todo, alert: "Failed to create comment." }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @comment.destroy

    respond_to do |format|
      format.html { redirect_to @todo, notice: "Comment was successfully deleted." }
      format.turbo_stream
    end
  end

  private

  def set_todo
    @todo = Todo.find(params[:todo_id])
  end

  def set_comment
    @comment = @todo.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :author)
  end
end
