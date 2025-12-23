class TodosController < ApplicationController
  before_action :set_todo, only: [:show, :edit, :update, :destroy, :toggle]

  def index
    @todos = Todo.ordered
    @filter = params[:filter] || "all"

    case @filter
    when "completed"
      @todos = @todos.completed
    when "pending"
      @todos = @todos.pending
    end
  end

  def show
  end

  def new
    @todo = Todo.new
  end

  def edit
  end

  def create
    @todo = Todo.new(todo_params)

    respond_to do |format|
      if @todo.save
        format.html { redirect_to todos_path, notice: "Todo was successfully created." }
        format.turbo_stream
      else
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @todo.update(todo_params)
        format.html { redirect_to todos_path, notice: "Todo was successfully updated." }
        format.turbo_stream
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :form_update, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @todo.destroy

    respond_to do |format|
      format.html { redirect_to todos_path, notice: "Todo was successfully deleted." }
      format.turbo_stream
    end
  end

  def toggle
    @todo.update(completed: !@todo.completed)

    respond_to do |format|
      format.html { redirect_to todos_path }
      format.turbo_stream
    end
  end

  def statistics
    sleep 1 # Simulate slow loading to demonstrate lazy loading

    @total_count = Todo.count
    @completed_count = Todo.completed.count
    @pending_count = Todo.pending.count
    @completion_rate = @total_count.zero? ? 0 : (@completed_count.to_f / @total_count * 100).round(1)

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def filter
    @filter = params[:filter] || "all"
    @todos = Todo.ordered

    case @filter
    when "completed"
      @todos = @todos.completed
    when "pending"
      @todos = @todos.pending
    end

    respond_to do |format|
      format.html { redirect_to todos_path(filter: @filter) }
      format.turbo_stream
    end
  end

  private

  def set_todo
    @todo = Todo.find(params[:id])
  end

  def todo_params
    params.require(:todo).permit(:title, :description, :completed, :position)
  end
end
