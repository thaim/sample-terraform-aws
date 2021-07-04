exports.handler = async (event, context) => {
  message = process.env.MESSAGE || "world";
  console.log("hello lambda image, hello " + message);

  const response = {
    staCode: 200,
    body: JSON.stringify(message)
  };
  return response;
};
