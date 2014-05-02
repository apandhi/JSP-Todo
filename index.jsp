<%@ page import="java.util.ArrayList,java.util.List,java.sql.*,javax.sql.*" %>
<%
	class ToDoItem{

		private int id;
		private String name;
		private String description;
		private int completed;

		public ToDoItem(int id, String name, String description, int completed){
			this.id = id;
			this.name = name;
			this.description = description;
			this.completed = completed;
		}

		public String getName(){
			return name;
		}

		public String getDescription(){
			return description;
		}
	}

	class TodoList{

		private java.sql.Connection con;

		public TodoList(java.sql.Connection con){
			this.con = con;
		}

		//Create a new list item
		//Returns number of rows affected
		public int createItem(String name, String description){
			int res = 0; //Default result - 0 rows affected
			try{
				String insStatement = "INSERT INTO `todos` (name, description) VALUES (?, ?)";
				//Create a prepared statement. This is much safer than a normal SQL update.
				PreparedStatement ins = this.con.prepareStatement(insStatement);
				ins.setString(1, name);
				ins.setString(2, description);	
				res = ins.executeUpdate();
			}catch (Exception e) {
			 	e.printStackTrace();
			}
			return res;
		}

		public List getTodos(){
			List<ToDoItem> lst = new ArrayList<ToDoItem>(); //Array list to be returned

			try{
				String selStatement = "SELECT * FROM `todos`";
				PreparedStatement sel = this.con.prepareStatement(selStatement);

				ResultSet rs = sel.executeQuery();

				// Fetch each row from the result set and insert it into the list
				while (rs.next()) {
				  int id = rs.getInt("id");
				  String name = rs.getString("name");
				  String description = rs.getString("description");
				  int completed = rs.getInt("completed");

				  ToDoItem item = new ToDoItem(id, name, description, completed);

				  lst.add(item);
				}	

			}catch (Exception e) {
			 	e.printStackTrace();
			}
			return lst;
		}

	}



		//Database settings
		String hostname = "localhost";
		String port = "3306";
		String database = "todo";
		String user = "user";
		String pass = "pass";

		//Create the class for the SQL driver
		Class.forName("com.mysql.jdbc.Driver");
		java.sql.Connection con = DriverManager.getConnection("jdbc:mysql://" + hostname + ":" + port + "/" + database, user, pass); 		

		//Pass the connection to the new TodoList object
		TodoList todo = new TodoList(con);

		//Create a new Todo item
		//todo.createItem("Lets see", "It works!"); 

		List<ToDoItem> tds = todo.getTodos(); //Gets a list of ToDoItem objects 

%>

<html>
	<body>
		Current task list:
		<ul>
			<%
				for(ToDoItem todo : tds){
					out.println("<li>");
					out.println(todo.getName());
					out.println(" - ");
					out.println(todo.getDescription());
					out.println("</li>");
				}
			%>
		</ul>
	</body>
</html>
