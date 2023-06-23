class TicketsController < ApplicationController
  def index
    if current_user.normal?
      conjunto = current_user.tickets
    elsif current_user.executive?
      conjunto = current_user.executive_tickets
    else
      conjunto = Ticket
    end

    if current_user.executive? || current_user.supervisor? || current_user.admin?
      if params[:search].present? && params[:title_search].present? && params[:description_search].present?
        @tickets = conjunto.joins(:normal_user).where(
          'users.email = ? OR tickets.title ILIKE ? OR tickets.description ILIKE ?',
          params[:search], "%#{params[:title_search]}%", "%#{params[:description_search]}%"
        )
      elsif params[:search].present? && params[:title_search].present?
        @tickets = conjunto.joins(:normal_user).where(
          'users.email = ? OR tickets.title ILIKE ?',
          params[:search], "%#{params[:title_search]}%"
        )
      elsif params[:search].present? && params[:description_search].present?
        @tickets = conjunto.joins(:normal_user).where(
          'users.email = ? OR tickets.description ILIKE ?',
          params[:search], "%#{params[:description_search]}%"
        )
      elsif params[:title_search].present? && params[:description_search].present?
        @tickets = conjunto.where(
          'tickets.title ILIKE ? OR tickets.description ILIKE ?',
          "%#{params[:title_search]}%", "%#{params[:description_search]}%"
        )
      elsif params[:search].present?
        @tickets = conjunto.joins(:normal_user).where(users: { email: params[:search] })
      elsif params[:title_search].present?
        @tickets = conjunto.where('tickets.title ILIKE ?', "%#{params[:title_search]}%")
      elsif params[:description_search].present?
        @tickets = conjunto.where('tickets.description ILIKE ?', "%#{params[:description_search]}%")
      elsif params[:sort_priority] == "priority"
        @tickets = conjunto.order(priority: :asc)
      elsif params[:sort_closeddate] == "closed_date"
        @tickets = conjunto.includes(:comments).order(closed_at: :desc)
      elsif params[:sort_last_comment_date] == "last_comment_date"
        @tickets = conjunto.includes(:comments).order("comments.created_at DESC")
      else
        @tickets = conjunto.includes(:comments).order("comments.created_at DESC")
      end
    else
      @tickets = conjunto.includes(:comments).order("comments.created_at DESC")
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
    @ticket = Ticket.find(params[:id])
    @ticket.destroy
    redirect_to tickets_path, notice: 'Ticket was successfully destroyed.'
  end

  def tickets_report
    if params[:start_date].present? && params[:end_date].present?
      start_date = params[:start_date].to_date
      end_date = params[:end_date].to_date
      @total_tickets = Ticket.where(created_at: start_date..end_date).count
      @open_tickets = Ticket.where(created_at: start_date..end_date, state: ['reopened', 'open']).count
      @closed_tickets = Ticket.where(created_at: start_date..end_date, state: 'closed').count
    else
      @total_tickets = 0
      @open_tickets = 0
      @closed_tickets = 0
    end
  end

  def executive_performance_report
    month = params[:month].to_i
    year = params[:year].to_i
    executives = User.where(role: 'executive')
    @report_data = executives.map do |executive|
      filtered_tickets = Ticket.where('extract(month from created_at) = ? AND extract(year from created_at) = ? AND executive_user_id = ?', month, year, executive.id)
      total_tickets_assigned = filtered_tickets.count
      total_tickets_closed = filtered_tickets.where(state: 'closed').count
      total_tickets_open = filtered_tickets.where(state: ['reopened', 'open']).count
      average_evaluation = filtered_tickets.average(:mark)
      {
        executive_name: executive.name,
        total_tickets_assigned: total_tickets_assigned,
        total_tickets_closed: total_tickets_closed,
        total_tickets_open: total_tickets_open,
        average_evaluation: average_evaluation
      }
    end
    render 'executive_performance_report', locals: {
      month: month,
      year: year,
      report_data: @report_data
    }
  end

  def show
    if current_user.normal?
      @ticket = current_user.tickets.find(params[:id])
    elsif current_user.executive?
      @ticket = current_user.executive_tickets.find(params[:id])
    else
      @ticket = Ticket.find(params[:id])
    end
  end

  private

  def ticket_params
    params.require(:ticket).permit(:title, :priority, :description, :tags).merge(state: 'open', acceptance: false)
  end
end