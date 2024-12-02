<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registrar Pregunta</title>
    <link href="./output.css" rel="stylesheet">
</head>
<body class="bg-gray-100 font-sans">

    <div class="container mx-auto p-6">
        <h1 class="text-3xl font-semibold mb-6">Registrar Nueva Pregunta</h1>
        
        <!-- Formulario de registro de preguntas -->
        <form action="<%= request.getContextPath()%>/insert" method="POST" class="bg-white shadow-md rounded-lg p-6">
            <div class="mb-4">
                <label for="pregunta" class="block text-gray-700 font-medium">Pregunta</label>
                <input type="text" id="pregunta" name="pregunta" placeholder="Escribe la pregunta aquí" required
                    class="mt-2 w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
            </div>
            <div class="mb-4">
                <label class="block text-gray-700 font-medium">Opciones de Respuesta</label>
                <div class="space-y-2 mt-2">
                    <input type="text" name="opcion1" placeholder="Opción 1" required class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <input type="text" name="opcion2" placeholder="Opción 2" required class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <input type="text" name="opcion3" placeholder="Opción 3" required class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <input type="text" name="opcion4" placeholder="Opción 4" required class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <input type="text" name="opcion5" placeholder="Opción 5" required class="w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                </div>
            </div>
            <div class="mb-4">
                <label for="estado" class="block text-gray-700 font-medium">Estado</label>
                <select id="estado" name="estado" required
                    class="mt-2 w-full p-3 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500">
                    <option value="active">Habilitada</option>
                    <option value="inactive">Deshabilitada</option>
                </select>
            </div>

            <div class="flex justify-end items-center mb-6">
                
                <div>
                    <button type="submit" class="bg-blue-500 text-white px-6 py-2 rounded-lg hover:bg-blue-600 focus:outline-none focus:ring-2 focus:ring-blue-500">Registrar Pregunta</button>
                    <button onclick="window.location.href='/encuesta/src/panel.jsp'" class="bg-gray-500 text-white px-6 py-2 rounded-lg hover:bg-gray-600 focus:outline-none focus:ring-2 focus:ring-gray-500">Ir a panel</button>
                </div>
                

            </div>
        </form>
    </div>

</body>
</html>
