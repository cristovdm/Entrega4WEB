class CommentsController < ApplicationController
    def create
      @ticket = Ticket.find(params[:ticket_id])
      @comment = @ticket.comments.build(comment_params)
      @comment.user = current_user
      @ticket.update(acceptance: false)
      if @comment.save
        redirect_to @ticket, notice: 'Comment was successfully created.'
      else
        render 'tickets/show'
      end
    end
  
    private
  
    def comment_params
      params.require(:comment).permit(:body)
    end
end