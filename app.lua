local lapis = require("lapis")
local config = require("lapis.config").get()
local respond_to = require("lapis.application").respond_to
local json_params = require("lapis.application").json_params
local app = lapis.Application()

products = {}
productId = 0

categories = {}
categoryId = 0

app:match("/", function(self)
  return config.greeting .. " from port " .. config.port
end)

app:match("/category", respond_to({
  before = function(self)
  end,
  GET = function(self)
    if self.params.id then
      for key,category in ipairs(categories) do
        if tostring(category.id) == self.params.id then
          return {
            json = {
              category
            }
          }
        end
      end
      return "Failed to retrieve category with given id"
    end
    return {
      json = {
        categories
      }
    }  end,
  POST = function(self)
    if self.params.id and self.params.name then
      for key,category in ipairs(categories) do
        if tostring(category.id) == self.params.id then
          product={id=self.params.id, name=self.params.name}
          table.insert(categories, category)
          return {
            json = {
              category
            }
          }
        end
      end
    end
    if self.params.categoryId and self.params.name then
      product={id=categoryId, name=self.params.name}
      table.insert(categories, category)
      categoryId=categoryId+1
      return {
        json = {
          category
        }
      }
    end
    return "Invalid params"
  end,
  DELETE = function(self)
    return "product deleted successfully"
  end
}))

app:match("/product", respond_to({
  before = function(self)
    if self.session.current_user then
      self:write({ redirect_to = "/" })
    end
  end,
  GET = function(self)
    if self.params.id then
      for key,product in ipairs(products) do
        if tostring(category.id) == self.params.id then
          return {
            json = {
              product
            }
          }
        end
      end
      return "Failed to retrieve product with given id"
    end
    return {
      json = {
        products
      }
    }  end,
  POST = function(self)
    if self.params.id and self.params.categoryId and self.params.name then
      for key,product in ipairs(products) do
        if tostring(category.id) == self.params.id then
          product={id=self.params.id, categoryId=self.params.categoryId, name=self.params.name}
          table.insert(products, product)
          return {
            json = {
              product
            }
          }
        end
      end
    end
    if self.params.categoryId and self.params.name then
      product={id=productId, categoryId=self.params.categoryId, name=self.params.name}
      table.insert(products, product)
      return {
        json = {
          product
        }
      }
    end
    return "Invalid params"
  end,
  DELETE = function(self)
    if self.params.id then
      for key,category in ipairs(categories) do
        if tostring(category.id) == self.params.id then
          categories[key] = nil
          return {
            json = {
              "Product removed successfully"
            }
          }
        end
      end
      return "There was no product with given id"
    end
    return "No id supplied"
  end
}))

return app