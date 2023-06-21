class TicketsController < ApplicationController
    def index
      if current_user.executive?
        if params[:search].present? && params[:title_search].present? && params[:description_search].present?
          @tickets = current_user.executive_tickets.joins(:normal_user).where(
            'users.email = ? OR tickets.title ILIKE ? OR tickets.description ILIKE ?',
            params[:search], "%#{params[:title_search]}%", "%#{params[:description_search]}%"
          )
        elsif params[:search].present? && params[:title_search].present?
          @tickets = current_user.executive_tickets.joins(:normal_user).where(
            'users.email = ? OR tickets.title ILIKE ?',
            params[:search], "%#{params[:title_search]}%"
          )
        elsif params[:search].present? && params[:description_search].present?
          @tickets = current_user.executive_tickets.joins(:normal_user).where(
            'users.email = ? OR tickets.description ILIKE ?',
            params[:search], "%#{params[:description_search]}%"
          )
        elsif params[:title_search].present? && params[:description_search].present?
          @tickets = current_user.executive_tickets.where(
            'tickets.title LIKE ? OR tickets.description ILIKE ?',
            "%#{params[:title_search]}%", "%#{params[:description_search]}%"
          )
        elsif params[:search].present?
          @tickets = current_user.executive_tickets.joins(:normal_user).where(users: { email: params[:search] })
        elsif params[:title_search].present?
          @tickets = current_user.executive_tickets.where('tickets.title ILIKE ?', "%#{params[:title_search]}%")
        elsif params[:description_search].present?
          @tickets = current_user.executive_tickets.where('tickets.description ILIKE ?', "%#{params[:description_search]}%")
        elsif params[:sort_priority] == "priority"
            @tickets = current_user.executive_tickets.order(priority: :asc)
        elsif params[:sort_closeddate] == "closed_date"
            @tickets = current_user.executive_tickets.includes(:comments).order(closed_at: :desc)
        elsif params[:sort_last_comment_date] == "last_comment_date"
          @tickets = current_user.executive_tickets.includes(:comments).order("comments.created_at DESC")
        else
          @tickets = current_user.executive_tickets.includes(:comments).order("comments.created_at DESC")
        end
      else
        @tickets = current_user.tickets.includes(:comments).order("comments.created_at DESC")
      end
    end
  
    def new
      @ticket = current_user.tickets.build(state: "open")
    end
  
    def create
        @ticket = current_user.tickets.build(ticket_params)
        @ticket.executive_user_id = User.executive.pluck(:id).sample
        if @ticket.save
          redirect_to @ticket, notice: 'Ticket was successfully created.'
        else
          render :new
        end
      end
  
    def edit
      @ticket = current_user.tickets.find(params[:id])
    end
  
    def update
      @ticket = current_user.tickets.find(params[:id])
      if @ticket.update(ticket_params)
        redirect_to @ticket, notice: 'Ticket was successfully updated.'
      else
        render :edit
      end
    end

    def update_acceptance
      @ticket = current_user.executive_tickets.find(params[:id])
      @ticket.update(acceptance: true)
      redirect_to @ticket, notice: 'Ticket acceptance updated successfully.'
    end

    def close
      if current_user.executive?
        @ticket = current_user.executive_tickets.find(params[:id])
      else
        @ticket = current_user.tickets.find(params[:id])
      end
      @ticket.update(state: 'closed', closed_at: DateTime.current)
      @ticket.update(mark: params[:ticket][:mark], acceptance: false)
      redirect_to @ticket, notice: 'Ticket was successfully closed.'
    end

    def reopen
      @ticket = current_user.executive_tickets.find(params[:id])
      @ticket.update(state: 'reopened')
      @ticket.update(acceptance: false)
      redirect_to @ticket, notice: 'Ticket was successfully reopened.'
    end
  
    def destroy
      @ticket = current_user.tickets.find(params[:id])
      @ticket.destroy
      redirect_to tickets_url, notice: 'Ticket was successfully destroyed.'
    end
  
    def show
        if current_user.executive?
            @ticket = current_user.executive_tickets.find(params[:id])
        else
            @ticket = current_user.tickets.find(params[:id])
        end
    end
    private
  
    def ticket_params
      params.require(:ticket).permit(:title, :priority, :description, :tags).merge(state: 'open', acceptance: false)
    end
end