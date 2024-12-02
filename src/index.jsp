<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.DriverManager" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Encuesta General</title>
    <link href="./output.css" rel="stylesheet">
    <style>
        .hidden { display: none; }

        .card {
            display: flex;
            position: relative;
            justify-content: center;
            align-items: center;
            overflow: hidden;
            cursor: pointer;
            z-index: 10;
        }

        .card-content {
            display: flex;
            justify-content: center;
            align-items: center;
            width: 100%;
            padding: 0.2rem;
            height: 4rem;
            transition: background-color 0.3s, color 0.3s, border-color 0.3s;
        }

        .card input[type="radio"]:checked ~ .card-content {
            background-color: #3b82f6; /* Azul cuando seleccionado */
            color: white;
            border-color: #3b82f6;
        }
        .card input[type="radio"]{
            position: absolute;
            overflow: hidden;
            height: 4rem;
            opacity: 0;
            cursor: pointer;
        }
        .card:hover .card-content {
            background-color: #e0f7ff;
        }

    </style>
</head>
<body class="bg-gray-100 min-h-screen flex items-center justify-center">
    <div class="bg-white shadow-md rounded-lg p-8 max-w-2xl w-full">
        <h1 class="text-3xl font-bold text-gray-800 mb-6 text-center">Encuesta General</h1>
        <form id="surveyForm" action="<%= request.getContextPath() %>/contador" method="POST">
            <% 
                // Configuración de la conexión a la base de datos
                String url = "jdbc:postgresql://127.0.0.1/encuesta";
                String username = "angel";
                String password = "123";
                int pageNum = 1;
                int questionCount = 0; // Contador para las preguntas por página

                // Declarar conexión y objetos
                Connection conn = null;
                PreparedStatement stmtPreguntas = null;
                PreparedStatement stmtOpciones = null;
                ResultSet rsPreguntas = null;
                ResultSet rsOpciones = null;

                try {
                    // Establecer la conexión
                    Class.forName("org.postgresql.Driver");
                    conn = DriverManager.getConnection(url, username, password);

                    // Consulta SQL para obtener preguntas
                    String queryPreguntas = "select id, pregunta from preguntas where estado = 'active'";
                    stmtPreguntas = conn.prepareStatement(queryPreguntas);
                    rsPreguntas = stmtPreguntas.executeQuery();

                    while (rsPreguntas.next()) {
                        int idPregunta = rsPreguntas.getInt("id");
                        String pregunta = rsPreguntas.getString("pregunta");
                        if (questionCount % 1 == 0) { // Si es una página nueva (dos preguntas por página)
                            if (questionCount > 0) {
                                pageNum++;
                            }
                            %>
                            <!-- Página dinámica -->
                            <div class="survey-page" id="page-<%= pageNum %>">
                            <% 
                        }
                        %>
                        <div class="relative mb-6">
                            <p class="text-gray-700 font-medium mb-3"><%= pregunta %></p>
                            <div class="space-y-3">
                                <% 
                                    // Consulta SQL para obtener opciones de la pregunta actual
                                    String queryOpciones = "select opcion from opciones_respuesta where pregunta_id = ?";
                                    stmtOpciones = conn.prepareStatement(queryOpciones);
                                    stmtOpciones.setInt(1, idPregunta);
                                    rsOpciones = stmtOpciones.executeQuery();

                                    while (rsOpciones.next()) {
                                        String opcion = rsOpciones.getString("opcion");
                                %>
                               
                                <div class="card relative border border-gray-300 rounded-lg shadow-md transition duration-300 hover:border-blue-500 hover:shadow-lg">
                                    <input type="radio" name="respuesta_<%= idPregunta %>" value="<%= opcion %>" class="absolute inset-0 w-full h-full opacity-0 cursor-pointer" required>
                                    <div class="card-content">
                                        <h3 class="text-xs font-semibold"><%= opcion %></h3>
                                    </div>
                                </div>
                                <% 
                                    }
                                %>
                            </div>
                        </div>
                        <% 
                        questionCount++;
                        if (questionCount % 1 == 0 || !rsPreguntas.next()) {
                            %>
                            </div> <!-- Cierra página actual si son dos preguntas o la última pregunta -->
                            <% 
                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    // Cerrar recursos
                    try {
                        if (rsOpciones != null) rsOpciones.close();
                        if (stmtOpciones != null) stmtOpciones.close();
                        if (rsPreguntas != null) rsPreguntas.close();
                        if (stmtPreguntas != null) stmtPreguntas.close();
                        if (conn != null) conn.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
            %>
            <% if (questionCount == 0) { %>
                <p class="text-red-500">No hay preguntas disponibles en este momento.</p>
            <% } %>
            
            <!-- Botones de navegación -->
            <div class="flex justify-between mt-6">
                <button type="button" id="prevBtn" class="hidden bg-gray-500 text-white py-2 px-4 rounded-lg hover:bg-gray-600">Anterior</button>
                <button type="button" id="nextBtn" class="bg-blue-500 text-white py-2 px-4 rounded-lg hover:bg-blue-600">Siguiente</button>
            </div>
        </form>
    </div>

    <script>
       document.addEventListener("DOMContentLoaded",()=> {
            console.log(<%= questionCount %>)
            let currentPage = 1;
            const totalPages = <%= pageNum %>; // Número total de páginas dinámicas
            const prevBtn = document.getElementById('prevBtn');
            const nextBtn = document.getElementById('nextBtn');
            showPage(currentPage);

            function showPage(page) {
                console.log("Mostrando página:", page); // Depuración
                document.querySelectorAll('.survey-page').forEach((page) => {
                    page.classList.add('hidden');
                });

                const current = document.getElementById('page-'+page);
                console.log(`Buscando ID: page-${page}`);  // Depuración
                if (current) {
                    current.classList.remove('hidden');
                    console.log(`Página ${page} encontrada y mostrada`);  // Depuración
                } else {
                    console.error(`No se encontró la página: ${page}`);  // Depuración
                }

                prevBtn.style.display = page === 1 ? 'none' : 'inline-block';
                nextBtn.textContent = page === totalPages ? 'Enviar' : 'Siguiente';
            }
            nextBtn.addEventListener('click', () => {
                const preguntas = document.querySelectorAll(`#page-${currentPage} .mb-6`); // Preguntas de la página actual
                let valido = true;

                // Limpiar mensajes de error previos
                document.querySelectorAll('.error-message').forEach((msg) => msg.remove());

                // Validar si todas las preguntas de la página actual tienen respuestas
                preguntas.forEach((pregunta) => {
                    const radios = pregunta.querySelectorAll('input[type="radio"]');
                    const seleccionado = Array.from(radios).some((radio) => radio.checked);

                    if (!seleccionado) {
                        valido = false;
                        const error = document.createElement('span');
                        error.textContent = "Por favor selecciona una respuesta.";
                        error.className = "error-message text-red-500 text-sm";
                        pregunta.appendChild(error);
                    }
                });

                // Si todas las respuestas están validadas, cambiar de página o enviar el formulario
                if (valido) {
                    if (currentPage < totalPages) {
                        currentPage++;
                        showPage(currentPage);
                    } else {
                        // Verificar si el formulario tiene elementos antes de enviarlo
                        const form = document.getElementById('surveyForm');
                        if (form.checkValidity()) {
                            form.submit(); // Enviar el formulario
                        } else {
                            alert("El formulario no es válido.");
                        }
                    }
                }
            });

           


            prevBtn.addEventListener('click', () => {
                if (currentPage > 1) {
                    currentPage--;
                    showPage(currentPage);
                }
            });
            
            
        });
    </script>
    
    
</body>
</html>
