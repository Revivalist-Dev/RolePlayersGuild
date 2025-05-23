<%@ Page Title="Manage To-Do Items on RPG" Language="C#" MasterPageFile="~/templates/2ColAdmin.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.Admin.ToDo.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="cphHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphTop" runat="server">
    <p>
        <a href="../">&laquo;&nbsp;Back to Admin Console</a>
    </p>

    <%--    <asp:FormView ID="FormView1" runat="server" DataKeyNames="ItemID" DataSourceID="sdsToDoItems" DefaultMode="Insert" Width="100%">
        <InsertItemTemplate>
            <div class="clearfix">
                <div class="col-sm-6">
                    <label>Title:</label>
                    <asp:TextBox ID="ItemNameTextBox" runat="server" CssClass="form-control" Text='<%# Bind("ItemName") %>' MaxLength="200" />
                </div>
                <div class="col-sm-12">
                    <label>Description:</label>
                    <asp:TextBox ID="ItemDescriptionTextBox" runat="server" CssClass="form-control" Text='<%# Bind("ItemDescription") %>' TextMode="MultiLine" Rows="5" />
                </div>
                <div class="col-sm-4">
                    <label>Status:</label>
                    <asp:DropDownList ID="DropDownList4" runat="server" CssClass="form-control" DataSourceID="sdsTodoStatuses" DataTextField="StatusName" DataValueField="StatusID" SelectedValue='<%# Bind("StatusID") %>'>
                    </asp:DropDownList>
                </div>
                <div class="col-sm-4">
                    <label>Type:</label>
                    <asp:DropDownList ID="DropDownList5" runat="server" CssClass="form-control" DataSourceID="sdsToDoTypes" DataTextField="TypeName" DataValueField="TypeID" SelectedValue='<%# Bind("TypeID") %>'>
                    </asp:DropDownList>
                </div>
                <div class="col-sm-4">
                    <label>Assigned To:</label>
                    <asp:DropDownList ID="DropDownList6" runat="server" CssClass="form-control" DataSourceID="sdsAssignToUsers" DataTextField="Username" DataValueField="UserID" SelectedValue='<%# Bind("AssignedToUserID") %>' AppendDataBoundItems="true">
                        <asp:ListItem Value="0" Text="No One"></asp:ListItem>
                    </asp:DropDownList>
                </div>
            </div>
            <div class="clearfix" style="margin: 1em 0;">
                <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" CommandName="Insert" CssClass="btn btn-success"><span class="glyphicon glyphicon-plus"></span>&nbsp;To-Do Item</asp:LinkButton>
            </div>
        </InsertItemTemplate>
    </asp:FormView>--%>
    <asp:UpdatePanel runat="server" ID="upToDoItems">
        <ContentTemplate>
            <div class="ButtonPanel clearfix">
                <div class="col-xl-3 col-sm-4 col-xs-12"></div>
                <div class="col-xl-3 col-sm-4 col-xs-12"></div>
                <div class="col-xl-3 col-sm-4 col-xs-12 col-xl-offset-3"><a href="Add-Item" class="btn btn-success"><span class="glyphicon glyphicon-plus"></span>&nbsp;To-Do Item</a></div>
            </div>
            <div class="ControlRow clearfix">
                <div class="form-group col-sm-2">
                    <label>Filtering</label>
                </div>
            </div>
            <asp:Panel runat="server" ID="pnlSearchBar" CssClass="ControlPanel form-inline clearfix SearchTools">
                <div class="ControlRow clearfix">
                    <div class="form-group col-sm-3">
                        <asp:DropDownList ID="ddlAssignedToFilter" ClientIDMode="Static" runat="server" CssClass="form-control" AutoPostBack="True" OnSelectedIndexChanged="btnSearch_Click" DataSourceID="sdsAssignToUsers" DataTextField="Username" DataValueField="UserID" AppendDataBoundItems="true">
                            <asp:ListItem Value="0" Text="Assigned To Any User"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group col-sm-3">
                        <asp:DropDownList ID="ddlStatusFilter" ClientIDMode="Static" runat="server" CssClass="form-control" AutoPostBack="True" OnSelectedIndexChanged="btnSearch_Click" DataSourceID="sdsTodoStatuses" DataTextField="StatusName" DataValueField="StatusID" AppendDataBoundItems="true">
                            <asp:ListItem Value="0" Text="All Open Items"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <div class="form-group col-sm-3">
                        <asp:DropDownList ID="ddlTypesFilter" ClientIDMode="Static" runat="server" CssClass="form-control" AutoPostBack="True" OnSelectedIndexChanged="btnSearch_Click" DataSourceID="sdsToDoTypes" DataTextField="TypeName" DataValueField="TypeID" AppendDataBoundItems="True">
                            <asp:ListItem Value="0" Text="All Types"></asp:ListItem>
                        </asp:DropDownList>
                    </div>
                </div>
            </asp:Panel>
            <div class="ControlRow clearfix">
                <div class="form-group col-sm-2">
                    <label>To-Do Items</label>
                </div>
            </div>
            <asp:GridView ID="gvToDoItems" runat="server" CssClass="ToDoList" AllowPaging="True" AutoGenerateColumns="False" DataKeyNames="ItemID" DataSourceID="sdsToDoItems" Width="100%" OnRowCommand="gvToDoItems_RowCommand" PageSize="20" ShowHeader="False">
                <Columns>
                    <asp:TemplateField HeaderText="Title" SortExpression="ItemName">
                        <EditItemTemplate>
                            <strong>Item #<asp:Label ID="Label6" runat="server" Text='<%# Bind("ItemID") %>'></asp:Label></strong>
                            - 
                            <asp:TextBox ID="TextBox1" runat="server" CssClass="form-control" Text='<%# Bind("ItemName") %>'></asp:TextBox>
                            <br />
                            <div class="clearfix">
                                <div class="form-group col-sm-4">
                                    <asp:DropDownList ID="DropDownList1" runat="server" CssClass="form-control" DataSourceID="sdsTodoStatuses" DataTextField="StatusName" DataValueField="StatusID" SelectedValue='<%# Bind("StatusID") %>'>
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group col-sm-4">
                                    <asp:DropDownList ID="DropDownList2" runat="server" CssClass="form-control" DataSourceID="sdsToDoTypes" DataTextField="TypeName" DataValueField="TypeID" SelectedValue='<%# Bind("TypeID") %>'>
                                    </asp:DropDownList>
                                </div>
                                <div class="form-group col-sm-4">
                                    <asp:DropDownList ID="DropDownList3" runat="server" CssClass="form-control" DataSourceID="sdsAssignToUsers" DataTextField="Username" DataValueField="UserID" SelectedValue='<%# Bind("AssignedToUserID") %>' AppendDataBoundItems="true">
                                        <asp:ListItem Value="0" Text="No One"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div>
                                Created By:
                            <a href="/Admin/Users?id=<%# Eval("CreatedByUserID") %>">
                                <asp:Label ID="Label5" runat="server" Text='<%# Bind("CreatedByUsername") %>'></asp:Label>&nbsp;&raquo;</a>
                                <br />
                                <asp:Label ID="Label7" runat="server" Text='<%# Bind("CreatedDateTime") %>'></asp:Label>
                                PST
                            </div>
                            <div style="margin-top: 1em;">
                                <asp:TextBox ID="TextBox2" runat="server" CssClass="form-control" Text='<%# Bind("ItemDescription") %>' TextMode="MultiLine" Rows="5"></asp:TextBox>
                            </div>

                        </EditItemTemplate>
                        <ItemTemplate>
                            <strong>Item #<asp:Label ID="Label6" runat="server" Text='<%# Bind("ItemID") %>'></asp:Label>
                                -
                                <asp:Label ID="Label1" runat="server" Text='<%# Bind("ItemName") %>'></asp:Label></strong>
                            <div style="font-size: 85%; line-height: 1em;">
                                <br />
                                <asp:Label ID="Label2" runat="server" Style="margin-top: 1em;" Text='<%# Bind("StatusName") %>'></asp:Label>
                                <asp:Label ID="Label3" runat="server" Style="margin-top: 1em;" Text='<%# Bind("TypeName") %>'></asp:Label>
                                for 
                            <asp:Label ID="Label4" runat="server" Style="margin-top: 1em;" Text='<%# Bind("AssignedToUsername") %>'></asp:Label>

                                <br />
                                <br />
                                Created By:
                            <a href="/Admin/Users?id=<%# Eval("CreatedByUserID") %>">
                                <asp:Label ID="Label5" runat="server" Text='<%# Bind("CreatedByUsername") %>'></asp:Label>&nbsp;&raquo;</a>
                                <br />
                                <br />
                                <asp:Label ID="Label7" runat="server" Text='<%# Bind("CreatedDateTime") %>'></asp:Label>
                                PST 
                            </div>
                            <div data-linkify>
                                <%# Eval("ItemDescription") %>
                            </div>

                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:CommandField ShowEditButton="True" />
                </Columns>
                <EmptyDataTemplate>
                    No To-Do Items to show.
                </EmptyDataTemplate>
            </asp:GridView>
            <asp:SqlDataSource ID="sdsTodoStatuses" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT StatusID, StatusName FROM ToDo_Item_Statuses ORDER BY StatusName"></asp:SqlDataSource>
            <asp:SqlDataSource ID="sdsToDoTypes" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [TypeID], [TypeName] FROM [ToDo_Item_Types] ORDER BY [TypeName]"></asp:SqlDataSource>
            <asp:SqlDataSource ID="sdsAssignToUsers" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT UserID, CAST(UserID AS Nvarchar) + ' - ' + ISNULL(Username, '') AS Username FROM Users Where UserTypeID = 2 or UserTypeID = 3 or UserTypeID = 4"></asp:SqlDataSource>
            <asp:SqlDataSource ID="sdsToDoItems" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" DeleteCommand="DELETE FROM [ToDo_Items] WHERE [ItemID] = @ItemID" InsertCommand="INSERT INTO ToDo_Items(ItemName, StatusID, TypeID, AssignedToUserID, CreatedByUserID, ItemDescription) VALUES (@ItemName, @StatusID, @TypeID, @AssignedToUserID, @CreatedByUserID, @ItemDescription)" UpdateCommand="UPDATE [ToDo_Items] SET [ItemName] = @ItemName, [ItemDescription] = @ItemDescription, [StatusID] = @StatusID, [TypeID] = @TypeID, [AssignedToUserID] = @AssignedToUserID WHERE [ItemID] = @ItemID">
                <DeleteParameters>
                    <asp:Parameter Name="ItemID" Type="Int32" />
                </DeleteParameters>
                <InsertParameters>
                    <asp:Parameter Name="ItemName" Type="String" />
                    <asp:Parameter Name="StatusID" Type="Int32" />
                    <asp:Parameter Name="TypeID" Type="Int32" />
                    <asp:Parameter Name="AssignedToUserID" Type="Int32" />
                    <asp:SessionParameter Name="CreatedByUserID" SessionField="UserID" Type="Int32" />
                    <asp:Parameter Name="ItemDescription" />
                </InsertParameters>
                <SelectParameters>
                    <asp:ControlParameter ControlID="ddlAssignedToFilter" Name="AssignedToUserID" PropertyName="SelectedValue" />
                    <asp:ControlParameter ControlID="ddlTypesFilter" Name="TypeID" PropertyName="SelectedValue" />
                    <asp:ControlParameter ControlID="ddlStatusFilter" Name="StatusID" PropertyName="SelectedValue" />
                </SelectParameters>
                <UpdateParameters>
                    <asp:Parameter Name="ItemName" Type="String" />
                    <asp:Parameter Name="ItemDescription" Type="String" />
                    <asp:Parameter Name="StatusID" Type="Int32" />
                    <asp:Parameter Name="TypeID" Type="Int32" />
                    <asp:Parameter Name="AssignedToUserID" Type="Int32" />
                    <asp:Parameter Name="ItemID" Type="Int32" />
                </UpdateParameters>
            </asp:SqlDataSource>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="cphLeftCol" runat="server">
</asp:Content>
<asp:Content ID="Content4" ContentPlaceHolderID="cphRightCol" runat="server">
</asp:Content>
<asp:Content ID="Content5" ContentPlaceHolderID="cphBottom" runat="server">
</asp:Content>
<asp:Content ID="Content6" ContentPlaceHolderID="cphScripts" runat="server">
</asp:Content>
