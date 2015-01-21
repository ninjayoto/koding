class ManageSharedView extends KDView

  constructor: (options = {}, data) ->

    options.cssClass = KD.utils.curry 'users-view', options.cssClass

    super options, data

    {@machine} = @getOptions()

    @addSubView @inputView = new KDView
      cssClass          : 'input-view'

    @inputView.addSubView @input = new KDHitEnterInputView
      type              : 'text'
      attributes        :
        spellcheck      : no

    @usersController    = new KDListViewController
      viewOptions       :
        type            : 'user'
        wrapper         : yes
        itemClass       : UserItem
        itemOptions     :
          machineId     : @machine._id

    @addSubView @userListView = @usersController.getView()
    @inputView.hide()

    @usersController.getListView()
      .on 'KickUserRequested', @bound 'kickUser'

    @addSubView @loader = new KDLoaderView
      cssClass          : 'in-progress'
      size              :
        width           : 14
        height          : 14
      loaderOptions     :
        color           : '#333333'
      showLoader        : yes

    @addSubView @warning = new KDCustomHTMLView
      cssClass          : 'warning hidden'
      click             : -> @hide()

    @listUsers()


  listUsers: ->

    @loader.show()

    @machine.jMachine.reviveUsers permanentOnly: yes, (err, users)=>
      warn err  if err?

      users ?= []
      @usersController.replaceAllItems users
      @userListView[if users.length > 0 then 'show' else 'hide']()

      @loader.hide()


  kickUser: (userItem)->

    @loader.show()
    @warning.hide()

    {profile:{nickname}} = userItem.getData()

    @machine.jMachine.shareWith
      target    : [nickname]
      permanent : yes
      asUser    : no
    , (err)=>

      @loader.hide()

      if err
        @warning.setTooltip title: err.message
        @warning.show()

      else
        if @usersController.itemsOrdered.length is 1
        then @listUsers()
        else @usersController.removeItem userItem


  toggleInput:->

    @inputView.toggleClass 'hidden'

    {windowController} = KD.singletons

    windowController.addLayer @input
    @input.setFocus()

    @input.off  "ReceivedClickElsewhere"
    @input.once "ReceivedClickElsewhere", (event)=>
      return  if $(event.target).hasClass 'toggle'
      @emit "UserInputCancelled"
      @inputView.hide()
      @warning.hide()
