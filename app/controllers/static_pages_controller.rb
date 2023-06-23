class StaticPagesController < ApplicationController
    def home
    end

    def edit_profile
        @user = current_user
    end

    def update_profile
        @user = current_user
        if @user.update(profile_params)
            redirect_to edit_profile_path, notice: 'Profile updated successfully.'
        else
            render :edit_profile
        end
    end

    def user_roles
        @users = User.where(role: [:normal, :executive])
    end
    
    def update_role
        @user = User.find(params[:id])
        new_role = @user.normal? ? :executive : :normal
        @user.update(role: new_role)
        redirect_to user_roles_path, notice: 'User role updated successfully.'
    end

    def manage_roles
        @users = User.where(role: [:normal, :executive, :supervisor])
    end

    def toggle_role
        @user = User.find(params[:id])
        @user.update(role: params[:user][:role])
        redirect_to manage_roles_path, notice: 'User role updated successfully.'
    end

    def supervisor_tickets
        if current_user.supervisor? || current_user.admin?
            order_by = params[:order_by]

            if order_by == 'priority'
              @tickets = Ticket.where(state: 'open').where('term_at < ?', Time.zone.now).order(priority: :desc)
            elsif order_by == 'last_comment'
              subquery = Comment.select('MAX(comments.created_at)')
                               .where('comments.ticket_id = tickets.id')
        
              @tickets = Ticket.joins(:comments)
                               .where(state: 'open')
                               .where('term_at < ?', Time.zone.now)
                               .where("comments.created_at = (#{subquery.to_sql})")
                               .order("comments.created_at DESC")
            else
              @tickets = Ticket.where(state: 'open').where('term_at < ?', Time.zone.now).order(term_at: :desc)
            end
          else
            redirect_to root_path, alert: 'Access denied.'
          end
        end


    private

    def profile_params
        params.require(:user).permit(:name, :last_name, :telephone)
    end
end
