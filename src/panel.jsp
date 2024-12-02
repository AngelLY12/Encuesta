<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.DriverManager" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Panel de Administración de Preguntas</title>
    <link href="./output.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">


</head>
<body class="bg-gray-100 font-sans">

    <div class="container mx-auto p-6">
        <h1 class="text-3xl font-semibold mb-6">Panel de Administración de Preguntas</h1>
        
        <!-- Tabla de preguntas -->
        <div class="mb-6">
            <div class="flex mb-6 justify-between items-center">
                <h2 class="text-2xl font-semibold mb-4">Preguntas Existentes</h2>
                <div >
                    <div class="w-full">
                        <button class="bg-blue-500 hover:bg-blue-600 text-white px-4 py-2 rounded-lg" onclick="window.location.href='/encuesta/src/registrar.jsp'">Agregar Pregunta</button>
                    <button class="bg-green-500 hover:bg-green-600 text-white px-4 py-2 rounded-lg" onclick="window.location.href='/encuesta/src/index.jsp'">Encuesta</button>
                    </div>
                    
                </div>
                
            </div>
            <table class="min-w-full bg-white shadow-md rounded-lg text-center">
                <thead>
                    <tr>
                        <th class="px-4 py-2 border">ID</th>
                        <th class="px-4 py-2 border">Pregunta</th>
                        <th class="px-4 py-2 border">Estado</th>
                        <th class="px-4 py-2 border">Acciones</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        // Configuración de la conexión a la base de datos
                        String url = "jdbc:postgresql://127.0.0.1/encuesta";
                        String username = "angel";
                        String password = "123";

                        // Declarar conexión y objetos
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;

                        try {
                            // Establecer la conexión
                            Class.forName("org.postgresql.Driver");
                            conn = DriverManager.getConnection(url, username, password);

                            // Consulta SQL para obtener preguntas
                            String query = "SELECT id, pregunta, estado FROM preguntas";
                            stmt = conn.prepareStatement(query);
                            rs = stmt.executeQuery();

                            // Iterar sobre el resultado
                            while (rs.next()) {
                                int id = rs.getInt("id");
                                String pregunta = rs.getString("pregunta");
                                String estado = rs.getString("estado");
                    %>
                    <!-- Aquí se iteran las preguntas desde el backend -->
                    <tr>
                        <td class="px-4 py-2 border"><%= id %></td>
                        <td class="px-4 py-2 border"><%= pregunta %></td>
                        <td class="px-4 py-2 border">
                            <% String currentState = estado != null ? estado : "inactive"; %>
                            <form action="<%= request.getContextPath()%>/status" method="post" id="form-<%= id %>">
                                <input type="hidden" name="id" value="<%= id %>">
                                <input type="hidden" name="estado" value="<%= "active".equals(currentState) ? "inactive" : "active" %>">
                                <button type="submit" class="<%= "active".equals(currentState) ? "bg-green-500" : "bg-red-500" %> text-white px-4 py-2 rounded-lg">
                                    <i class="<%= "active".equals(currentState) ? "fas fa-toggle-on" : "fas fa-toggle-off" %>"></i>
                                </button>
                            </form>
                        </td>
                        
                        
                        
                        <td class="px-4 py-2 border">
                            <div class="flex justify-center items-center">
                                <div>
                                    <button class="bg-blue-500 text-white px-4 py-2 rounded-lg" onclick="window.location.href='/encuesta/src/editar.jsp?id=<%=id%>'">
                                        <i class="fas fa-edit"></i>
                                    </button>     
                                    <button class="bg-red-500 text-white px-4 py-2 rounded-lg"  onclick="openModal(<%= id %>)">
                                        <i class="fas fa-trash"></i>
                                    </button>  
                                    <button class="bg-yellow-500 text-white px-4 py-2 rounded-lg" onclick="window.location.href='/encuesta/src/graficas.jsp?id=<%=id%>'">
                                        <i class="fas fa-chart-bar"></i>
                                    </button>  
                                </div>
                                 
                            </div>
                                             
                            
                        </td>
                    </tr>
                    <% 
                            } // Fin del while
                        } catch (Exception e) {
                            e.printStackTrace();
                        } finally {
                            // Cerrar recursos
                            try {
                                if (rs != null) rs.close();
                                if (stmt != null) stmt.close();
                                if (conn != null) conn.close();
                            } catch (SQLException e) {
                                e.printStackTrace();
                            }
                        }
                    %>
                </tbody>
            </table>
            
        </div>
        <form action="<%= request.getContextPath() %>/todasGraficas" method="get" class="w-full relative my-6 flex justify-center">
            <button type="submit" class="bg-yellow-500 hover:bg-purple-600 text-white font-medium px-6 py-2 rounded-lg">Gráficas</button>
        </form>
    </div>
    <div id="modal-bg" class="fixed inset-0 bg-gray-800 bg-opacity-75 hidden flex items-center justify-center z-100">
        <div class="bg-white rounded-lg shadow-lg p-6 max-w-md w-full mx-auto">
            <h2 class="text-lg font-bold mb-4">¿Estás seguro de eliminar este registro?</h2>
            <form method="post">
                <input type="hidden" id="delete-id" name="id">
                <div class="flex justify-end gap-4">
                    <button type="submit" class="bg-red-500 text-white px-4 py-2 rounded hover:bg-red-700">
                        Eliminar
                    </button>
                    <button type="button" class="bg-gray-300 px-4 py-2 rounded hover:bg-gray-400" onclick="closeModal()">
                        Cancelar
                    </button>
                </div>
            </form>
        </div>
    </div>
    

    <script>
        function openModal(id) {
            document.getElementById('delete-id').value = id;
            document.getElementById('modal-bg').classList.remove('hidden');
        }

        function closeModal() {
            document.getElementById('modal-bg').classList.add('hidden');
        }
    </script>
    <%
    //Eliminar
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String id = request.getParameter("id");
        if (id != null) {
            String deleteQuery = "DELETE FROM preguntas WHERE id = ?";
            try (Connection connection = DriverManager.getConnection(url, username, password);
                 PreparedStatement statement = connection.prepareStatement(deleteQuery)) {
                statement.setInt(1, Integer.parseInt(id));
                int rowsDeleted = statement.executeUpdate();
                if (rowsDeleted > 0) {
                    out.println("<script>alert('Usuario eliminado correctamente');</script>");
                    response.sendRedirect("/encuesta/src/panel.jsp");
                } else {
                    out.println("<script>alert('Error al eliminar el usuario');</script>");
                }
            } catch (SQLException e) {
                out.println("<script>alert('Error al conectar con la base de datos: " + e.getMessage() + "');</script>");
            }
        }
    }
%>
</body>
</html>
